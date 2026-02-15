# Configurar un puerto TTY persistente para RPLIDAR A1 en Linux (udev)

Cuando conectas el **RPLIDAR A1**, Linux normalmente lo asigna como:

```
/dev/ttyUSB0
/dev/ttyUSB1
```

El problema es que **puede cambiar** si conectas otro dispositivo USB-serial (Arduino, FTDI, etc.).

Para evitar eso, crearemos un alias permanente:

```
/dev/rplidar
```

---

## 1. Verificar el dispositivo conectado

Conecta el LiDAR y ejecuta:

```bash
udevadm info -q all -n /dev/ttyUSB0
```

Busca algo como:

```
E: SUBSYSTEM=tty
E: ID_VENDOR_ID=10c4
E: ID_MODEL_ID=ea60
E: ID_SERIAL_SHORT=0001
```

El **RPLIDAR A1 normalmente usa chip CP2102**, por lo que suele tener:

```
ID_VENDOR_ID=10c4
ID_MODEL_ID=ea60
```

También puedes filtrar:

```bash
udevadm info -q all -n /dev/ttyUSB0 | grep ID_VENDOR_ID
udevadm info -q all -n /dev/ttyUSB0 | grep ID_SERIAL_SHORT
```

---

## 2. Elegir identificador

### ✅ Opción A (RECOMENDADA): usar número de serie

Si aparece:

```
ID_SERIAL_SHORT=0001
```

> Es la forma más segura si hay varios dispositivos CP2102.

---

### ⚠️ Opción B: usar vendor + product (genérico RPLIDAR A1)

```
ID_VENDOR_ID=10c4
ID_MODEL_ID=ea60
```

> Si conectas otro dispositivo CP2102 podría generar conflicto.

---

## 3. Crear la regla udev

Crear archivo:

```bash
sudo nano /etc/udev/rules.d/99-rplidar.rules
```

---

### ✅ Regla usando número de serie (recomendada)

```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="0001", SYMLINK+="rplidar", MODE="0666"
```

> Usa tu número real

---

### ⚠️ Regla genérica RPLIDAR A1 (CP2102)

```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="rplidar", MODE="0666"
```

---

## 4. Recargar reglas

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Desconecta y vuelve a conectar el LiDAR.

---

## 5. Verificar

```bash
ls -l /dev/rplidar
```

Debe mostrar algo como:

```
/dev/rplidar -> ttyUSB0
```

---

## 6. Probar con ROS Noetic

Si usas el driver oficial:

Slamtec fabrica el RPLIDAR.

RPLIDAR A1 funciona normalmente a:

```
115200 baud
```

En tu launch:

```xml
<param name="serial_port" value="/dev/rplidar"/>
<param name="serial_baudrate" value="115200"/>
```

Luego:

```bash
roslaunch rplidar_ros rplidar.launch
```

Y verifica:

```bash
rostopic echo /scan
```

---

## Caso típico en laboratorio (Arduino + LiDAR)

Después de esto tendrás:

```
/dev/arduino
/dev/rplidar
```

Esto es clave cuando:

* Reinicias la Raspberry
* Reinicias la VM
* Conectas múltiples USB
* Cambias orden de conexión

---

## 7. Permisos

Si aparece:

```
Permission denied
```

Agregar usuario a `dialout`:

```bash
sudo usermod -aG dialout $USER
```

Cerrar sesión y volver a entrar.

---

## Resultado final

Cada vez que conectes el LiDAR:

```
/dev/rplidar
```

siempre será el mismo.

En robótica móvil esto evita:

* Que el LiDAR se conecte como ttyUSB1
* Que ROS falle al arrancar
* Que el laboratorio se vuelva caos