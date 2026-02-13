#!/bin/bash

REPO_URL="https://github.com/chucholoport/turtle_robot_sketchbook.git"
DEST_DIR="$HOME/sketchbook"

# Valores por defecto
REMOVE=false
BRANCH="feature/arduino_uno"   # default

# Parsear flags
while getopts "rb:" opt; do
  case $opt in
    r) REMOVE=true ;;
    b) BRANCH=$OPTARG ;;
    *) echo "Uso: $0 [-r] [-b <branch>]"; exit 1 ;;
  esac
done

# Validar branch permitido
if [ "$BRANCH" != "feature/arduino_uno" ] && [ "$BRANCH" != "feature/arduino_mega" ]; then
    echo "Branch inválido: $BRANCH"
    echo "Opciones válidas: feature/arduino_uno (default), feature/arduino_mega"
    exit 1
fi

# Lógica principal
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