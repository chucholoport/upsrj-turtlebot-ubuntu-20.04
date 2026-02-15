# Conexión entre VM Ubuntu y Raspberry Pi

### (Contexto de Red + VNC + SSH)

Este flujo permite:

* Visualizar el escritorio gráfico de la **Raspberry Pi** desde una **VM Ubuntu** usando **VNC**
* Acceder por terminal usando **SSH**
* Comprender cómo funciona la asignación de IP dentro de la red local

---

## Contexto de Red (Muy Importante)

Antes de intentar conectarse, es fundamental entender cómo están conectados los equipos.

### Escenario típico de laboratorio

```
Router / Access Point
        │
        ├── VM Ubuntu (ej. 192.168.2.50)
        └── Raspberry Pi (ej. 192.168.2.70)
```

Ambos dispositivos deben:

* Estar en **la misma red**
* Compartir el mismo segmento IP (ej. `192.168.2.X`)
* Tener la misma máscara de red (normalmente `255.255.255.0`)

---

### Verificar IP en la Raspberry Pi

En la Raspberry:

```bash
ip addr
```

Busca algo como:

```
inet 192.168.2.70/24
```

Eso significa:

* IP: `192.168.2.70`
* Máscara: `/24` → 255.255.255.0
* Red: `192.168.2.0`

---

### Verificar IP en la VM Ubuntu

En la VM:

```bash
ip addr
```

Debe mostrar algo como:

```
inet 192.168.2.50/24
```

Si la VM tiene una IP tipo:

```
10.0.2.15
```

Entonces está en **modo NAT**, y no podrá ver directamente la Raspberry.

En ese caso debes cambiar el adaptador de red de la VM a:
* **Bridged Adapter (Adaptador Puente)** 

Esto permite que la VM obtenga una IP del mismo router que la Raspberry.

---

## 🖥️ Desde la VM (Ubuntu Desktop)

### 1. Instalar el visor VNC

```bash
sudo apt update
sudo apt install tigervnc-viewer -y
```

---

### 2. Conectarse al escritorio remoto

Si el hostname `turtle` resuelve correctamente:

```bash
vncviewer turtle:1
```

Si no resuelve, usa directamente la IP:

```bash
vncviewer 192.168.2.70:1
```

#### ¿Qué significa `:1`?

VNC usa puertos basados en el display:

| Display | Puerto |
| ------- | ------ |
| :0      | 5900   |
| :1      | 5901   |
| :2      | 5902   |

Entonces:

```
192.168.2.70:1 → puerto 5901
```

---

### 3. Conexión SSH a la Raspberry

```bash
ssh turtle@192.168.2.70
```

Donde:

* `turtle` → usuario en la Raspberry
* `192.168.2.70` → IP de la Raspberry

Si es la primera vez, aparecerá:

```
Are you sure you want to continue connecting?
```

Responder:

```
yes
```

---

## 🐢 Desde la Raspberry Pi (Turtle Robot)

### 1. Instalar entorno gráfico y servidor VNC

```bash
sudo apt update
sudo apt install xfce4 xfce4-goodies lightdm -y
sudo apt install tightvncserver -y
```

---

### 2. Configurar entorno de inicio para VNC

```bash
mkdir -p ~/.vnc
nano ~/.vnc/xstartup
```

Agregar:

```bash
#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
```

---

### 3. Hacer ejecutable

```bash
chmod +x ~/.vnc/xstartup
```

---

### 4. Iniciar el servidor VNC

```bash
vncserver :1
```

Esto crea:

* Display virtual `:1`
* Puerto TCP `5901`

---

## Verificar conectividad antes de usar VNC

Desde la VM:

### Probar ping

```bash
ping 192.168.2.70
```

Si responde, hay conectividad IP.

---

### Verificar puerto abierto

```bash
nc -zv 192.168.2.70 5901
```

Si el puerto está abierto, VNC debería funcionar.

---

## Problemas comunes y diagnóstico

### No hace ping

Posibles causas:

* VM en modo NAT
* Raspberry en otra red WiFi
* Firewall bloqueando ICMP
* IP incorrecta

---

### SSH funciona pero VNC no

Revisar:

```bash
ps aux | grep vnc
```

O reiniciar:

```bash
vncserver -kill :1
vncserver :1
```

---

### Hostname no resuelve (turtle)

Revisar:

```bash
ping turtle
```

Si no resuelve, puedes:

* Usar IP directamente
* Agregar entrada en `/etc/hosts` en la VM:

```bash
sudo nano /etc/hosts
```

Agregar:

```
192.168.2.70 turtle
```