#!/bin/bash

# --- Configuración ---
RPLIDAR_DRIVER="ros-noetic-rplidar-ros"
ROSSERIAL="ros-noetic-rosserial"
ROSSERIAL_PYTHON="ros-noetic-rosserial-python"
ROSSERIAL_ARDUINO="ros-noetic-rosserial-arduino"
HECTOR_SLAM="ros-noetic-hector-slam"
MAP_SERVER="ros-noetic-map-server"

# Función: validar que ROS esté instalado
validate_ros() {
    if ! command -v rospack >/dev/null 2>&1; then
        echo "Error: ROS Noetic no está instalado o no está en el PATH."
        echo "Instala ROS Noetic antes de continuar: http://wiki.ros.org/noetic/Installation/Ubuntu"
        exit 1
    else
        echo "ROS Noetic detectado correctamente."
    fi
}

# Función: verificar e instalar un paquete ROS
check_install_ros_pkg() {
    local pkg=$1
    echo "Verificando paquete $pkg..."
    if rospack list | grep -q "$(basename $pkg)"; then
        echo "Paquete $pkg ya está instalado."
    else
        echo "Paquete $pkg no está instalado. Instalando..."
        sudo apt update
        sudo apt install -y "$pkg"
        if rospack list | grep -q "$(basename $pkg)"; then
            echo "Paquete $pkg instalado correctamente."
        else
            echo "Error: no se pudo instalar el paquete $pkg."
            exit 1
        fi
    fi
}

# Función principal
main() {
    validate_ros
    check_install_ros_pkg "$RPLIDAR_DRIVER"
    check_install_ros_pkg "$ROSSERIAL"
    check_install_ros_pkg "$ROSSERIAL_PYTHON"
    check_install_ros_pkg "$ROSSERIAL_ARDUINO"
    check_install_ros_pkg "$HECTOR_SLAM"
    check_install_ros_pkg "$MAP_SERVER"
    echo "Instalación y verificación de drivers ROS completada."
}

# --- Ejecutar ---
main