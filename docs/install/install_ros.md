# Instalación de ROS Noetic en Ubuntu 20.04

> ROS Noetic está oficialmente soportado en **Ubuntu 20.04 (Focal Fossa)**.

---

## 1. Configurar repositorios oficiales de ROS

Agregar el repositorio oficial:

```bash
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```

Agregar la llave GPG:

```bash
sudo apt install -y curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

Actualizar lista de paquetes:

```bash
sudo apt update
```

---

## 2. Instalar ROS

## 🖥️ En la VM Ubuntu (Desktop)

Instalar versión completa con herramientas gráficas:

```bash
sudo apt install -y ros-noetic-desktop-full
```

Incluye:

* roscore
* rviz
* rqt
* turtlesim
* herramientas de desarrollo

Esta versión es ideal para la máquina donde se desarrollará y visualizará.

---

## 🐢 En la Raspberry Pi (Turtle Robot)

En la Raspberry **NO se instala desktop-full**.

Se instala únicamente la versión base:

```bash
sudo apt install -y ros-noetic-ros-base
```

Esto incluye:

* roscore
* roslaunch
* comunicación entre nodos
* librerías básicas

No incluye herramientas gráficas pesadas como rviz.

> **Motivo:**
> La Raspberry tiene menos recursos y generalmente ejecuta solo nodos y el master, mientras que la visualización se hace desde la VM.

---

## 3. Inicializar rosdep

En ambas máquinas:

```bash
sudo apt install -y python3-rosdep
sudo rosdep init
rosdep update
```

---

## 4. Configurar el entorno en `.bashrc`

Editar:

```bash
nano ~/.bashrc
```

Agregar:

```bash
# Configuración ROS Noetic
source /opt/ros/noetic/setup.bash
```

Guardar y recargar:

```bash
source ~/.bashrc
```

Probar:

```bash
roscore
```

Si inicia correctamente, ROS está configurado.

---

## 5. Crear el workspace `turtle_ws`

En ambas máquinas (recomendado mantener misma estructura):

```bash
mkdir -p ~/turtle_ws/src
cd ~/turtle_ws
catkin_make
```

Luego agregar al `.bashrc`:

```bash
nano ~/.bashrc
```

Agregar debajo de la línea anterior:

```bash
source ~/turtle_ws/devel/setup.bash
```

Recargar:

```bash
source ~/.bashrc
```

Verificar:

```bash
echo $ROS_PACKAGE_PATH
```

Debe incluir:

```
/home/usuario/turtle_ws/src
```

---

## 6. Probar instalación básica

En la VM:

```bash
roscore
```

En otra terminal:

```bash
rosrun turtlesim turtlesim_node
```

En la Raspberry (si solo es base):

```bash
roscore
```

---

## Estructura esperada del workspace

```bash
~/turtle_ws/
 ├── build/
 ├── devel/
 └── src/
```

---

## Script automatizado disponible

Ya existe un script que automatiza:

* Instalación de ROS (desktop-full o base según equipo)
* Inicialización de rosdep
* Creación del workspace `turtle_ws`
* Actualización automática del `.bashrc`