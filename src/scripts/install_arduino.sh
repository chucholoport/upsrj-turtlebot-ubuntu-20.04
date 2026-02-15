#!/bin/bash

# --- Configuración ---
REPO_URL="https://github.com/chucholoport/turtle_robot_sketchbook.git"
DEST_DIR="$HOME/sketchbook"

# Branches válidos
VALID_BRANCHES=("feature/arduino_uno" "feature/arduino_mega")

# Herramientas a instalar
ARDUINO_IDE="arduino"
ARDUINO_CLI="arduino-cli"

# Valores por defecto
REMOVE=false
BRANCH="${VALID_BRANCHES[0]}"   # default: feature/arduino_uno

# Parsear flags
while getopts "rb:" opt; do
  case $opt in
    r) REMOVE=true ;;
    b) BRANCH=$OPTARG ;;
    *) echo "Uso: $0 [-r] [-b <branch>]"; exit 1 ;;
  esac
done

# Función: validar branch contra array recibido
validate_branch() {
    local branch_to_check=$1
    shift
    local valid_branches=("$@")

    local valid=false
    for b in "${valid_branches[@]}"; do
        if [ "$branch_to_check" == "$b" ]; then
            valid=true
            break
        fi
    done

    if [ "$valid" = false ]; then
        echo "Branch inválido: $branch_to_check"
        echo "Opciones válidas: ${valid_branches[*]}"
        exit 1
    fi
}

# Función: verificar e instalar una keyword
check_install() {
    local kw=$1
    if command -v "$kw" >/dev/null 2>&1; then
        echo "$kw ya está instalado."
    else
        echo "$kw no está instalado. Instalando..."
        sudo apt update
        sudo apt install -y "$kw"
        if command -v "$kw" >/dev/null 2>&1; then
            echo "$kw instalado correctamente."
        else
            echo "Error: no se pudo instalar $kw."
            exit 1
        fi
    fi
}

# Función: lógica principal de clonación/actualización
manage_sketchbook() {
    if [ -d "$DEST_DIR/.git" ]; then
        echo "Actualizando sketchbook existente en branch $BRANCH..."
        cd "$DEST_DIR" && git fetch origin && git checkout "$BRANCH" && git pull origin "$BRANCH"
    else
        if [ -d "$DEST_DIR" ] && [ "$REMOVE" = true ]; then
            echo "Eliminando carpeta existente y clonando branch $BRANCH..."
            rm -rf "$DEST_DIR"
            git clone -b "$BRANCH" "$REPO_URL" "$DEST_DIR"
        elif [ -d "$DEST_DIR" ]; then
            echo "La carpeta $DEST_DIR ya existe y no está vacía."
            echo "Ejecuta con -r si quieres borrarla y clonar de nuevo."
            exit 1
        else
            echo "Clonando sketchbook por primera vez en branch $BRANCH..."
            git clone -b "$BRANCH" "$REPO_URL" "$DEST_DIR"
        fi
    fi
}

# --- Flujo principal ---
validate_branch "$BRANCH" "${VALID_BRANCHES[@]}"

# Instalar Arduino IDE y CLI
check_install "$ARDUINO_IDE"
check_install "$ARDUINO_CLI"

manage_sketchbook