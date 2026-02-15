#!/bin/bash

# --- Configuración ---
PRIMARY_MANAGER="NetworkManager"
OTHER_MANAGERS=("systemd-networkd" "wicd" "netplan")

# Función: validar si NetworkManager está instalado
validate_networkmanager() {
    if ! command -v nmcli >/dev/null 2>&1; then
        echo "Error: NetworkManager no está instalado."
        echo "Instalando NetworkManager..."
        sudo apt update
        sudo apt install -y network-manager
    else
        echo "NetworkManager detectado correctamente."
    fi
}

# Función: desactivar otros gestores de red
disable_other_managers() {
    for mgr in "${OTHER_MANAGERS[@]}"; do
        if systemctl list-unit-files | grep -q "$mgr"; then
            echo "Desactivando $mgr..."
            sudo systemctl stop "$mgr"
            sudo systemctl disable "$mgr"
        fi
    done
}

# Función: habilitar y arrancar NetworkManager
enable_networkmanager() {
    echo "Habilitando $PRIMARY_MANAGER..."
    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
    sudo systemctl restart NetworkManager
    echo "$PRIMARY_MANAGER está activo y configurado como único gestor de red."
}

# Función principal
main() {
    validate_networkmanager
    disable_other_managers
    enable_networkmanager
    echo "Configuración de red corregida: solo NetworkManager está activo."
}

# --- Ejecutar ---
main