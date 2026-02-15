# Configurar un puerto TTY persistente para Arduino en Linux (udev)

En Linux, cuando conectamos un Arduino, el sistema lo asigna dinámicamente como:

```
/dev/ttyACM0
/dev/ttyACM1
/dev/ttyUSB0
```

El problema es que **este nombre puede cambiar** al reconectar el dispositivo o conectar otro puerto serial.

Para evitarlo, crearemos una **regla udev** que genere un alias permanente llamado:

```
/dev/arduino
```

---

## 1. Verificar el dispositivo conectado

Conecta el Arduino y ejecuta:

```bash
udevadm info -q all -n /dev/ttyACM0
```

Busca los siguientes campos importantes:

```bash
E: SUBSYSTEM=tty
E: ID_VENDOR_ID=2341
E: ID_MODEL_ID=0042
E: ID_SERIAL_SHORT=12754501101131852446
```

También puedes filtrarlos directamente:

```bash
udevadm info -q all -n /dev/ttyACM0 | grep SUBSYSTEM
udevadm info -q all -n /dev/ttyACM0 | grep ID_SERIAL_SHORT
```

---

## 2. Elegir el identificador adecuado

Tienes dos opciones:

### ✅ Opción A (RECOMENDADA): usar el número de serie único

Más segura cuando hay varios Arduinos.

```
ID_SERIAL_SHORT=12754501101131852446
```

### ⚠️ Opción B: usar vendor + model

Menos específica (si hay varios iguales puede fallar).

```
ID_VENDOR_ID=2341
ID_MODEL_ID=0042
```

---

## 3. Crear la regla udev

Crear archivo:

```bash
sudo nano /etc/udev/rules.d/99-arduino.rules
```

Agregar una de estas reglas:

---

### ✅ Regla usando número de serie (recomendada)

```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0042", ATTRS{serial}=="12754501101131852446", SYMLINK+="arduino", MODE="0666"
```

---

### ⚠️ Regla genérica (ATmega16U2)

```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", SYMLINK+="arduino", MODE="0666"
```

### ⚠️ Regla genérica (Uno Clon CH340)

```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SYMLINK+="arduino", MODE="0666"
```

### ⚠️ Regla genérica (todos los Mega 2560)

```bash
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0042", SYMLINK+="arduino", MODE="0666"
```

---

## 4. Recargar reglas udev

Después de guardar:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Desconecta y vuelve a conectar el Arduino.

---

## 5. Verificar que funciona

Ejecuta:

```bash
ls -l /dev/arduino
```

Debe aparecer algo como:

```
/dev/arduino -> ttyACM0
```

Ahora puedes usar siempre:

```
/dev/arduino
```

en lugar de `/dev/ttyACM0`.

---

## 6. Probar comunicación

Ejemplo con screen:

```bash
screen /dev/arduino 115200
```

O desde ROS / Python:

```python
port = "/dev/arduino"
```

---

## 7. Permisos (si da error de acceso)

Si aparece:

```
Permission denied
```

Agregar usuario al grupo dialout:

```bash
sudo usermod -aG dialout $USER
```

Cerrar sesión y volver a entrar.

---

## Resultado final

Cada vez que conectes ese Arduino:

```
/dev/arduino
```

siempre existirá, sin importar si cambia a ttyACM0, ttyACM1, etc.

Esto es **fundamental en robótica**, ya que evita fallos cuando se reinicia el sistema o se conectan múltiples dispositivos seriales.