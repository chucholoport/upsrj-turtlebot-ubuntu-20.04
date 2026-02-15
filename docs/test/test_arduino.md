# Test Arduino – Comunicación ROS ↔ Arduino (Toggle LED)

Esta guía describe el proceso para:

* Verificar rosserial
* Conectar Arduino a ROS Noetic
* Probar comunicación usando el script `toggle_led.py`
* Confirmar funcionamiento del LED en el pin 13

Este test utiliza el paquete **turtle_robot** y el nodo `toggle_led.py`.

---

## 1. Requisitos

Entorno:

* Ubuntu 20.04
* ROS Noetic
* Arduino Uno o Mega
* rosserial instalado
* Sketch cargado en Arduino (toggle LED)

Instalar rosserial si no está:

```bash
sudo apt update
sudo apt install ros-noetic-rosserial ros-noetic-rosserial-python ros-noetic-rosserial-arduino
```

Verificar instalación:

```bash
rospack list | grep rosserial
```

---

## 2. Confirmar puerto del Arduino

Si configuraste regla udev:

```
/dev/arduino
```

Verificar:

```bash
ls -l /dev/arduino
```

Si no usas alias:

```bash
ls -l /dev/ttyACM*
```

---

## 3. Cargar el sketch en Arduino

El siguiente código debe estar cargado en la placa:

* Subscriber: `/toggle_led`
* Tipo: `std_msgs/Bool`
* LED: pin 13

(El sketch ya proporcionado en el paquete turtle_robot.)

---

## 4. Iniciar rosserial

En una terminal:

```bash
roscore
```

En otra terminal:

Si usas alias:

```bash
rosrun rosserial_python serial_node.py /dev/arduino
```

Si no:

```bash
rosrun rosserial_python serial_node.py /dev/ttyACM0
```

Si la conexión es correcta, verás algo como:

```
[INFO] Note: publish buffer size is ...
[INFO] Setup complete
```

---

## 5. Ejecutar el nodo toggle_led

Dar permisos si es necesario:

```bash
chmod +x scripts/toggle_led.py
```

Ejecutar:

```bash
rosrun turtle_robot toggle_led.py
```

Salida esperada:

```
Publicando LED: True
Publicando LED: False
...
```

El LED del Arduino debe encenderse y apagarse cada segundo.

---

## 6. Publicación manual (modo diagnóstico)

También puedes probar sin el script:

Encender LED:

```bash
rostopic pub /toggle_led std_msgs/Bool "data: true"
```

Apagar LED:

```bash
rostopic pub /toggle_led std_msgs/Bool "data: false"
```

---

## 7. Verificar comunicación ROS

Confirmar que el tópico existe:

```bash
rostopic list
```

Debe aparecer:

```
/toggle_led
```

Ver tráfico en tiempo real:

```bash
rostopic echo /toggle_led
```

---

## 8. Flujo completo de prueba

```bash
roscore
rosrun rosserial_python serial_node.py /dev/arduino
rosrun turtle_robot toggle_led.py
```

---

## 9. Problemas comunes

### Permission denied

```bash
sudo usermod -aG dialout $USER
```

Cerrar sesión y volver a entrar.

---

### Unable to sync with device

Verificar:

* Baudrate correcto en el sketch
* Puerto correcto
* Que el Arduino no esté abierto en el IDE

---

### No parpadea el LED

Verificar:

* Sketch correcto cargado
* Pin 13 configurado como OUTPUT
* Que rosserial esté conectado sin errores

---

## Resultado esperado

* ROS publica en `/toggle_led`
* rosserial transmite por USB
* Arduino recibe mensaje
* LED en pin 13 cambia de estado

---

## Objetivo didáctico

Este ejercicio demuestra:

* Integración de hardware real como nodo ROS
* Comunicación Publisher → Subscriber
* Uso de rosserial
* Validación básica antes de integrar motores o sensores