# ROS Noetic – Conexión distribuida entre VM (Ubuntu) y Raspberry Pi (turtle)

Este documento describe cómo configurar una arquitectura distribuida en ROS Noetic, donde:

- La **Raspberry Pi (turtle)** ejecuta el `roscore` y el nodo gráfico `turtlesim_node`.
- La **VM Ubuntu** ejecuta el teleop (`teleop_twist_keyboard` o `turtle_teleop_key`) para controlar la tortuga.

---

## 1. Crear alias `turtle.local` con Avahi (mDNS)

En la Raspberry Pi:

```bash
sudo apt install avahi-daemon -y
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon
```

Configura el hostname:

```bash
sudo hostnamectl set-hostname turtle
sudo systemctl restart avahi-daemon
```

Prueba desde la VM:

```bash
ping turtle.local
```

## 2. Configurar variables ROS en `.bashrc`

### En la Raspberry Pi (`turtle`)

Edita `~/.bashrc` y agrega:

```bash
export ROS_MASTER_URI=http://turtle.local:11311
export ROS_HOSTNAME=turtle
```

### En la VM Ubuntu

Edita `~/.bashrc` y agrega:

```bash
export ROS_MASTER_URI=http://turtle.local:11311
export ROS_HOSTNAME=ubuntu
```

Reemplaza `<IP_VM>` por la IP real de tu VM en modo bridged (ej. `192.168.2.80`).

Recarga en ambas máquinas:

```bash
source ~/.bashrc
```

---

## 3. Alternativa: Conexión con `/etc/hosts`

Si prefieres usar alias fijos en lugar de mDNS:

En **ambas máquinas**, edita `/etc/hosts`:

```bash
sudo nano /etc/hosts
```

Agrega:
```
192.168.2.70   turtle
192.168.2.80   ubuntu
```

Luego en la Raspberry:
```bash
export ROS_MASTER_URI=http://turtle:11311
export ROS_HOSTNAME=turtle
```

Y en la VM:
```bash
export ROS_MASTER_URI=http://turtle:11311
export ROS_HOSTNAME=ubuntu
```

---

## 4. Probar la conexión distribuida

### En la Raspberry Pi

1. Levanta el master:

   ```bash
   roscore
   ```

2. Ejecuta el nodo gráfico:

   ```bash
   rosrun turtlesim turtlesim_node
   ```

### En la VM Ubuntu

1. Ejecuta el teleop con remapeo:

   ```bash
   rosrun teleop_twist_keyboard teleop_twist_keyboard.py cmd_vel:=/turtle1/cmd_vel
   ```

   o usa el teleop específico:

   ```bash
   rosrun turtlesim turtle_teleop_key
   ```

---

## Validación

- En la Raspberry, la ventana de `turtlesim_node` debe moverse al presionar teclas en la VM.  
- Verifica los mensajes en la Raspberry:
  
  ```bash
  rostopic echo /turtle1/cmd_vel
  ```
  
  Debes ver los comandos de velocidad enviados desde la VM.