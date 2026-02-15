#!/bin/bash

# --- Configuración ---
BROWSER="firefox"

# Función: validar si Firefox está instalado
validate_browser() {
    if command -v $BROWSER >/dev/null 2>&1; then
        echo "$BROWSER ya está instalado."
    else
        echo "$BROWSER no está instalado. Procediendo a instalar..."
        install_browser
    fi
}

# Función: instalar Firefox
install_browser() {
    sudo apt update
    sudo apt install -y $BROWSER
    if command -v $BROWSER >/dev/null 2>&1; then
        echo "$BROWSER instalado correctamente."
    else
        echo "Error: no se pudo instalar $BROWSER."
        exit 1
    fi
}

# Función principal
main() {
    validate_browser
    echo "Instalación y verificación de Firefox completada."
}

# --- Ejecutar ---
main