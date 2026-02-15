# Test RPLIDAR A1 – Instalación y Verificación en ROS Noetic

Esta guía describe el proceso completo para:

* Instalar el driver del RPLIDAR A1
* Confirmar que está correctamente instalado
* Lanzar el nodo
* Visualizar datos en RViz

---

## 1. Instalación del Driver

Actualizar repositorios:

```bash
sudo apt update
```

Instalar el paquete oficial:

```bash
sudo apt install ros-noetic-rplidar-ros
```

---

## 2. Confirmar que el paquete está instalado

Verificar que ROS reconoce el paquete:

```bash
rospack list | grep rplidar
```

Salida esperada:

```
rplidar_ros /opt/ros/noetic/share/rplidar_ros
```

Si aparece esa línea, el driver está correctamente instalado.

---

## 3. Lanzar RPLIDAR con RViz automático

Para prueba rápida (abre RViz ya configurado):

```bash
roslaunch rplidar_ros view_rplidar_a1.launch
```

Esto:

* Inicia el nodo del LiDAR
* Abre RViz automáticamente
* Muestra el escaneo en tiempo real

---

## 4. Lanzar manualmente (modo recomendado para integración)

Si estás usando regla udev y tu LiDAR aparece como:

```
/dev/rplidar
```

Ejecuta:

```bash
roslaunch rplidar_ros rplidar_a1.launch serial_port:=/dev/rplidar
```

Si no tienes alias udev:

```bash
roslaunch rplidar_ros rplidar_a1.launch serial_port:=/dev/ttyUSB0
```

---

## 5. Visualizar en RViz manualmente

En otra terminal:

```bash
rviz
```

Configurar:

* Fixed Frame → `laser`
* Add → LaserScan
* Topic → `/scan`

Si todo está correcto, verás los puntos del escaneo en tiempo real.

---

## 6. Verificación adicional

Confirmar que el LiDAR está publicando datos:

```bash
rostopic list
```

Debe aparecer:

```
/scan
```

Ver datos crudos:

```bash
rostopic echo /scan
```

Si aparecen rangos y ángulos → el LiDAR funciona correctamente.

---

## 7. Posibles errores comunes

### Cannot open serial port

Verificar:

```bash
ls -l /dev/ttyUSB*
```

Si hay error de permisos:

```bash
sudo usermod -aG dialout $USER
```

Cerrar sesión y volver a entrar.

---

### No se ve nada en RViz

Verificar:

```bash
rostopic echo /scan
```

Si hay datos pero no se visualiza:

* Revisar que Fixed Frame = `laser`
* Confirmar que el topic seleccionado sea `/scan`

---

## 8. Flujo mínimo funcional

```bash
roscore
roslaunch rplidar_ros rplidar_a1.launch serial_port:=/dev/rplidar
rviz
```

---

## Resultado esperado

* El LiDAR gira
* ROS publica `/scan`
* RViz muestra el entorno en 2D

---

## Nota

Ya existe un script de instalación automatizada para los drivers ROS (rplidar y rosserial).
Este documento deja explícito el proceso manual para fines educativos y de diagnóstico.