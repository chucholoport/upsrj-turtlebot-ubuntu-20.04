#!/bin/bash

# --- Configuración ---
UBUNTU_MATE_MINIMAL="ubuntu-mate-core"
DISPLAY_MANAGER="lightdm"

# Función: validar que estamos en Raspberry Pi con Ubuntu
validate_system() {
    if ! grep -q "raspberrypi" /proc/device-tree/model 2>/dev/null; then
        echo "Advertencia: este script está diseñado para Raspberry Pi."
    else
        echo "Raspberry Pi detectada correctamente."
    fi
    if ! command -v apt >/dev/null 2>&1; then
        echo "Error: este sistema no usa apt. Abortando."
        exit 1
    fi
}

# Función: instalar Ubuntu MATE mínimo
install_mate_minimal() {
    echo "Instalando entorno mínimo de Ubuntu MATE..."
    sudo apt update
    sudo apt install -y $UBUNTU_MATE_MINIMAL
    echo "Ubuntu MATE mínimo instalado."
}

# Función: instalar y configurar LightDM
install_lightdm() {
    echo "Instalando y configurando $DISPLAY_MANAGER..."
    sudo apt install -y $DISPLAY_MANAGER
    sudo dpkg-reconfigure $DISPLAY_MANAGER
    sudo systemctl enable $DISPLAY_MANAGER
    sudo systemctl start $DISPLAY_MANAGER
    echo "$DISPLAY_MANAGER configurado como gestor de display predeterminado."
}

# Función: flujo principal
main() {
    validate_system
    install_mate_minimal
    install_lightdm
    echo "Instalación de Ubuntu MATE mínimo y LightDM completada. El sistema arrancará en GUI."
}

# --- Ejecutar ---
main