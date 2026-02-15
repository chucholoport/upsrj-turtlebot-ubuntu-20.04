# ROS Noetic – Conexión distribuida entre VM (Ubuntu) y Raspberry Pi (turtle)

Arquitectura distribuida usando **ROS Noetic**.

En esta práctica:

* La **Raspberry Pi (turtle)** ejecuta el `roscore` y `turtlesim_node`.
* La **VM Ubuntu** ejecuta el teleop para controlar la tortuga.
* Ambos equipos se comunican mediante TCP/IP dentro de la misma red local.

---

## 1. Verificar contexto de red (ANTES de configurar ROS)

Ambos equipos deben:

* Estar en la misma red (ej. `192.168.2.0/24`)
* Poder hacerse ping
* Estar en modo **Bridged** (no NAT)

---

### Verificar IP

En ambas máquinas:

```bash
ip addr
```

Ejemplo válido:

* Raspberry → `192.168.2.70/24`
* VM → `192.168.2.80/24`

Si la VM tiene algo como:

```
10.0.2.15
```

Está en modo NAT y no funcionará ROS distribuido.

---

### Probar conectividad

Desde la VM:

```bash
ping 192.168.2.70
```

Desde la Raspberry:

```bash
ping 192.168.2.80
```

Si no hay ping, no continúes.

---

## 2. Configurar alias fijos usando `/etc/hosts`

Para evitar problemas de resolución de nombres, usaremos resolución estática.

### En **ambas máquinas**:

```bash
sudo nano /etc/hosts
```

Agregar:

```
192.168.2.70   turtle
192.168.2.80   ubuntu
```

Guardar y salir.

Probar desde cada máquina:

```bash
ping turtle
ping ubuntu
```

Si responde correctamente, la resolución funciona.

---

## 3. Configurar variables ROS en `.bashrc`

Estas variables son críticas para ROS1.

---

### 🐢 En la Raspberry Pi (Turtle Robot)

Editar:

```bash
nano ~/.bashrc
```

Agregar al final:

```bash
export ROS_MASTER_URI=http://turtle:11311
export ROS_HOSTNAME=turtle
```

---

### 💻 En la VM Ubuntu

Editar:

```bash
nano ~/.bashrc
```

Agregar:

```bash
export ROS_MASTER_URI=http://turtle:11311
export ROS_HOSTNAME=ubuntu
```

---

Recargar en ambas máquinas:

```bash
source ~/.bashrc
```

Verificar:

```bash
echo $ROS_MASTER_URI
echo $ROS_HOSTNAME
```

---

## 4. Probar la conexión distribuida

### 🐢 En la Raspberry Pi

Levantar el master:

```bash
roscore
```

Ejecutar el nodo gráfico:

```bash
rosrun turtlesim turtlesim_node
```

El paquete utilizado es **turtlesim**.

---

### 💻 En la VM Ubuntu

Ejecutar teleop:

```bash
rosrun teleop_twist_keyboard teleop_twist_keyboard.py cmd_vel:=/turtle1/cmd_vel
```

O alternativamente:

```bash
rosrun turtlesim turtle_teleop_key
```

El paquete usado es **teleop_twist_keyboard**.

---

## ✅ Validación

En la Raspberry:

```bash
rostopic echo /turtle1/cmd_vel
```

Si todo está correcto:

* Al presionar teclas en la VM
* Se publican mensajes en la Raspberry
* La tortuga se mueve en la ventana gráfica

---

## Diagnóstico rápido si no funciona

1. ¿Hay ping entre máquinas?
2. ¿Está corriendo `roscore`?
3. ¿Resuelve correctamente `turtle`?
4. ¿El puerto 11311 está abierto?

Probar desde la VM:

```bash
nc -zv turtle 11311
```

---

## Concepto Clave

En **ROS1**:

* El Master (11311) solo coordina.
* Luego los nodos se conectan directamente entre sí.
* Si `ROS_HOSTNAME` no es resolvible, la comunicación falla.