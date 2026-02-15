# Test SLAM con Hector y RPLIDAR

**Objetivo:**
Generar un mapa 2D del entorno usando **Hector SLAM** y **RPLIDAR A1**, comprendiendo la relación entre **frames**, **transforms** y tópicos en ROS Noetic.

**Entorno esperado:**

* Ubuntu 20.04 (VM o máquina física)
* ROS Noetic instalado
* Paquete `rplidar_ros` instalado
* Paquete `hector_slam` instalado
* Nodo `static_transform_publisher` disponible
* RViz para visualización

---

## Terminal 1: Publicar transform estático

Hector SLAM necesita conocer la relación entre la base del robot y el LIDAR.
Ejecuta **antes de levantar el RPLIDAR**:

```bash
rosrun tf static_transform_publisher 0 0 0 0 0 0 base_footprint laser 100
```

* Publica un transform estático de `base_footprint` → `laser`
* `100` → frecuencia de publicación en Hz

> Nota: siempre iniciar este transform antes de levantar el nodo del RPLIDAR.

---

## Terminal 2: Levantar el RPLIDAR

```bash
roslaunch rplidar_ros rplidar_a1.launch
```

* Publica datos tipo `sensor_msgs/LaserScan` en `/scan`
* Verifica la comunicación:

```bash
rostopic echo /scan | head
```

Deberías ver algo como:

```yaml
header:
  frame_id: "laser"
angle_min: -3.14159
angle_max: 3.14159
...
```

---

## Terminal 3: Levantar Hector SLAM

```bash
rosrun hector_mapping hector_mapping \
  _base_frame:=base_footprint \
  _odom_frame:=base_footprint \
  _map_frame:=map \
  _use_tf_scan_transformation:=true \
  _pub_map_odom_transform:=true
```

* `base_footprint` → frame del robot
* `map` → frame global de referencia
* `odom_frame` → odometría interna (Hector puede usar la misma que la base)
* `_use_tf_scan_transformation:=true` → utiliza los transforms publicados

**Verificación rápida:**

```bash
rosrun tf tf_echo base_footprint laser
```

Debe mostrar una transformación válida, por ejemplo:

```
Translation: [0.000, 0.000, 0.000]
Rotation: [0.000, 0.000, 0.000, 1.000]
```

---

## Terminal 4: Abrir RViz y configurar displays

1. Lanza RViz directamente:

```bash
rviz
```

2. Configura `Fixed Frame` en **`map`**
3. Agrega los siguientes displays:

| Display   | Topic / Frame    | Descripción                    |
| --------- | ---------------- | ------------------------------ |
| Grid      | N/A              | Plano de referencia            |
| LaserScan | `/scan`          | Muestra los datos del RPLIDAR  |
| Map       | `/map`           | Mapa generado por Hector SLAM  |
| Pose      | `/slam_out_pose` | Posición estimada del robot    |
| Path      | `/slam_out_pose` | Traza la trayectoria del robot |

4. Configura cada display según corresponda:

   * `LaserScan`: Topic → `/scan`, Queue Size → 10
   * `Map`: Topic → `/map`, Color Scheme → `map`
   * `Pose` y `Path`: Topic → `/slam_out_pose`

> Ahora deberías ver el LIDAR en tiempo real, el mapa en construcción y la posición/recorrido del robot.

---

## Terminal 5: Guardar el mapa

Cuando tengas un mapa estable y cubras la zona de interés:

```bash
rosrun map_server map_saver -f ~/turtle_map
```

* Se generan `turtle_map.pgm` y `turtle_map.yaml` en tu home
* Listo para usarlo después en navegación o simulación

---

## ✅ Checklist de SLAM

| Elemento                                        | Estado esperado |
| ----------------------------------------------- | --------------- |
| Transform estático base_footprint → laser       | ✅               |
| RPLIDAR A1 publicando en `/scan`                | ✅               |
| Hector SLAM levantando `/map`                   | ✅               |
| RViz mostrando Grid, LaserScan, Map, Pose, Path | ✅               |
| Guardado del mapa con `map_saver`               | ✅               |

---

**Objetivos pedagógicos:**

* Comprender la relación **base_footprint ↔ laser ↔ map**
* Visualizar la publicación de tópicos y transforms en ROS
* Integrar sensores reales con nodos SLAM
* Configurar RViz manualmente para inspección de datos
* Guardar mapas para su reutilización posterior