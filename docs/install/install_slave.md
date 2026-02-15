# Instalación Slave: Raspberry Pi (Robot)

Este documento describe la preparación de la Raspberry Pi, que actuará como Slave en la arquitectura Master-Slave.

La Raspberry ejecutará:

- Ubuntu Server 20.04 ARM
- rplidar_ros
- rosserial_python
- Drivers de hardware
- Comunicación con Arduino

---

## Previo: Versión recomendada de Raspberry Pi Imager

Se recomienda utilizar:

Raspberry Pi Imager 1.9.6

Las versiones más recientes pueden:

* Limitar la personalización previa
* No permitir definir usuario personalizado
* Cambiar el comportamiento de configuración inicial

Para laboratorio educativo, la versión 1.9.6 permite:

* Definir usuario y contraseña antes de grabar
* Activar SSH previamente
* Configurar WiFi antes del primer arranque
* Definir hostname personalizado

Esto permite trabajar sin monitor ni teclado.

---

## 1. Instalar Raspberry Pi Imager

Descargar desde:

[https://www.raspberrypi.com/software/](https://www.raspberrypi.com/software/)

Instalar versión 1.9.6.

---

## 2. Descargar Ubuntu 20.04 para Raspberry

Desde:

[https://cdimage.ubuntu.com/releases/20.04/release/](https://cdimage.ubuntu.com/releases/20.04/release/)

Archivo recomendado:

```
ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz
```

---

## 3. Grabar la microSD

Abrir Raspberry Pi Imager:

* Use custom image → seleccionar la imagen descargada
* Storage → microSD

---

## 4. Personalización previa (ANTES de grabar)

Configurar:

Hostname:

```
turtle
```

Enable SSH:

```
True
```

Usuario:

```
turtle
```

Contraseña:

```
turtle
```

WiFi:

* SSID: tu red
* Password: tu clave
* País: MX (o el correspondiente)

Esto permite:

* Conexión automática a red
* Acceso remoto vía SSH
* Configuración sin periféricos

---

## 5. Primer arranque

Insertar microSD y encender Raspberry.

Desde la VM (Master):

```bash
ping turtle.local
```

o

```bash
ssh turtle@turtle.local
```

---

## 6. Rol del Slave en la arquitectura

La Raspberry ejecutará:

* rplidar_ros (LiDAR montado físicamente en el robot)
* rosserial_python (Arduino conectado por USB)
* Controladores de hardware
* Publicación de /scan y /wheel_rpm

El LiDAR NO se conecta al Master.
El Arduino NO se conecta al Master.

Todo hardware está conectado físicamente a la Raspberry.

---

## 7. Verificación final

Checklist:

| Elemento                   | Estado esperado |
| -------------------------- | --------------- |
| microSD grabada            | ✅               |
| Raspberry inicia           | ✅               |
| Conectada a red            | ✅               |
| SSH funcional              | ✅               |
| Puede hacer ping al Master | ✅               |

---

## Resultado esperado:

La Raspberry está lista para:

* Instalar ROS Noetic
* Ejecutar drivers de hardware
* Comunicarse con el Master vía ROS multimáquina