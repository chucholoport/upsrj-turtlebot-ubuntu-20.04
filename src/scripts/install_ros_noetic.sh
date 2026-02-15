#!/bin/bash

# --- Configuración ---
ROS_DISTRO="noetic"
WORKSPACE="$HOME/turtle_ws"

# Versiones válidas
VALID_VARIANTS=("desktop-full" "ros-base")

# Valores por defecto
VARIANT="${VALID_VARIANTS[0]}"   # default: desktop-full

# Parsear flags
while getopts "v:" opt; do
  case $opt in
    v) VARIANT=$OPTARG ;;
    *) echo "Uso: $0 [-v <desktop-full|ros-base>]"; exit 1 ;;
  esac
done

# Validar variante seleccionada
if [[ ! " ${VALID_VARIANTS[@]} " =~ " ${VARIANT} " ]]; then
    echo "Error: Variante inválida."
    echo "Opciones válidas: desktop-full | ros-base"
    exit 1
fi

# Función: instalar ROS Noetic (según guía oficial)
install_ros_noetic() {
    echo "Instalando ROS $ROS_DISTRO ($VARIANT) en Ubuntu 20.04..."

    # Configurar repositorios
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt install -y curl
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

    # Actualizar e instalar variante seleccionada
    sudo apt update
    sudo apt install -y ros-$ROS_DISTRO-$VARIANT

    # Inicializar rosdep
    sudo apt install -y python3-rosdep
    sudo rosdep init 2>/dev/null
    rosdep update

    echo "ROS $ROS_DISTRO ($VARIANT) instalado correctamente."
}

# Función: configurar catkin workspace
setup_catkin_ws() {
    echo "Configurando workspace en $WORKSPACE..."
    mkdir -p "$WORKSPACE/src"
    cd "$WORKSPACE" || exit 1
    catkin_make
    echo "Workspace $(basename $WORKSPACE) creado y compilado."
}

# Función: actualizar .bashrc
update_bashrc() {
    echo "Actualizando .bashrc..."
    
    if ! grep -q "/opt/ros/$ROS_DISTRO/setup.bash" ~/.bashrc; then
        echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
    fi

    if ! grep -q "$WORKSPACE/devel/setup.bash" ~/.bashrc; then
        echo "source $WORKSPACE/devel/setup.bash" >> ~/.bashrc
    fi

    # Recargar configuración en la sesión actual
    source ~/.bashrc
    echo ".bashrc actualizado con configuración de ROS $ROS_DISTRO y $(basename $WORKSPACE)."
}

# Función principal
main() {
    install_ros_noetic
    setup_catkin_ws
    update_bashrc
    echo "Instalación y configuración de ROS $ROS_DISTRO y $(basename $WORKSPACE) completada."
}

# --- Ejecutar ---
main
