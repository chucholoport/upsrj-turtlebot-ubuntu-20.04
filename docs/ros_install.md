# Instalación de ROS Noetic en Ubuntu 20.04

En Ubuntu 20.04, la instalación de ROS Noetic se hace agregando el repositorio oficial de ROS, importando la clave GPG, actualizando paquetes y luego instalando `ros-noetic-desktop-full`.  

---

## Instalación en VM con Ubuntu 20.04

### 1. Configura las fuentes de ROS

Agrega el repositorio oficial:

```bash
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
```

### 2. Añade la clave GPG

```bash
sudo apt install curl -y
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

### 3. Actualiza índices de paquetes

```bash
sudo apt update
```

### 4. Instala ROS Noetic

Instalación completa con todas las herramientas y simuladores:

```bash
sudo apt install ros-noetic-desktop-full -y
```

> Si quieres algo más ligero, puedes instalar `ros-noetic-ros-base`.

### 5. Configura el entorno
    
Agrega ROS al entorno de tu shell:

```bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

### 6. Instala dependencias para compilar
    
```bash
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
```

Inicializa `rosdep`:
```bash
sudo rosdep init
rosdep update
```
---

## Pruebas

### 1. Instalar `turtlesim`

En tu VM Ubuntu 20.04 con ROS Noetic:

```bash
sudo apt install ros-noetic-turtlesim -y
```

### 2. Levantar el `roscore`

En una terminal:

```bash
roscore
```

Esto inicia el maestro de ROS.

### 3. Ejecutar el nodo gráfico

En otra terminal:

```bash
rosrun turtlesim turtlesim_node

```

Se abrirá la ventana con la tortuga.

### 4. Controlar la tortuga con teleop

Instala el paquete de teleop:

```bash
sudo apt install ros-noetic-teleop-twist-keyboard -y
```

Ejecuta el teleop en una nueva terminal:

```bash
rosrun teleop_twist_keyboard teleop_twist_keyboard.py
```

ROS Noetic incluye un teleop específico para turtlesim:

```bash
rosrun turtlesim turtle_teleop_key
```

Usa las teclas **W, A, S, D** para mover la tortuga.

---

## Validación
- La ventana de `turtlesim_node` debe responder a tus teclas.  
- Puedes verificar los mensajes con:
  ```bash
  rostopic echo /turtle1/cmd_vel
  ```
  Verás los comandos de velocidad que se envían.

---

## Instalación de ROS Noetic en Raspberry Pi con Ubuntu 20.04

### 1. Configurar repositorios de ROS

```bash
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
```

### 2. Añadir la clave GPG

```bash
sudo apt install curl -y
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

### 3. Actualizar índices de paquetes

```bash
sudo apt update
```

### 4. Instalar ROS Noetic

En Raspberry conviene instalar la versión **base** para ahorrar recursos:

```bash
sudo apt install ros-noetic-ros-base -y
```

> Si quieres usar `turtlesim` u otros paquetes gráficos, puedes añadirlos después:

```bash
sudo apt install ros-noetic-turtlesim -y
```

---

### 5. Configurar entorno

Agrega ROS al entorno de tu shell:

```bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

### 6. Instalar dependencias de compilación

```bash
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
```

Inicializa `rosdep`:

```bash
sudo rosdep init
rosdep update
```

---

## Validación

En la Raspberry:

```bash
roscore
```
Si arranca el servidor maestro, la instalación fue exitosa.

---

## NOTAS
- En la **VM**: instala `ros-noetic-desktop-full` para simulación y visualización.  
- En la **Raspberry**: instala `ros-noetic-ros-base` + paquetes específicos (ej. `turtlesim`, drivers de sensores).  

---