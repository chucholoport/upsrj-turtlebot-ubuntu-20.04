# Instalación Master: Máquina Virtual Ubuntu (PC)

Este documento describe la preparación de la máquina principal (Master), que ejecutará los nodos de alto nivel del sistema robótico.

El Master NO controla hardware directamente, ejecuta nodos de alto nivel para análisis, control y cálculo de trayectoria.

Ejecutará:

- roscore
- RViz
- Teleop
- SLAM / navegación
- Herramientas de desarrollo

### Arquitectura:
La Raspberry Pi (Slave) será quien ejecute rplidar y rosserial.

---

## 1. Instalar Hypervisor

Descargar e instalar VMware:

[https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)

* Windows/Linux → VMware Workstation Pro
* macOS → VMware Fusion

---

## 2. Descargar Ubuntu Desktop 20.04 LTS

Descargar desde:

[https://www.releases.ubuntu.com/focal/](https://www.releases.ubuntu.com/focal/)

Archivo recomendado:

```
ubuntu-20.04.6-desktop-amd64.iso
```

---

## 3. Crear la Máquina Virtual

Configuración recomendada:

| Parámetro          | Valor                        |
| ------------------ | ---------------------------- |
| Sistema operativo  | Ubuntu 64-bit                |
| RAM                | 2 GB mínimo (ideal 4 GB)     |
| Disco              | 20 GB mínimo (modo dinámico) |
| CPU                | 2 núcleos                    |
| Adaptadores de red | 2                            |

---

## 4. Configuración de Red (IMPORTANTE)

Agregar **dos adaptadores**:

### Adaptador 1 – NAT

* Permite acceso a internet
* Necesario para instalar ROS y dependencias

### Adaptador 2 – Bridged

* Permite que la VM esté en la misma red que la Raspberry
* Necesario para ROS multimáquina
* Permite SSH directo a la Raspberry

---

## 5. Verificación final

Checklist:

| Elemento                                  | Estado esperado |
| ----------------------------------------- | --------------- |
| VMware instalado                          | ✅               |
| ISO descargada                            | ✅               |
| VM creada                                 | ✅               |
| Ubuntu inicia correctamente               | ✅               |
| Internet funcionando (NAT)                | ✅               |
| Puede hacer ping a la Raspberry (Bridged) | ✅               |

---

## Resultado esperado

La VM debe:

* Tener acceso a internet
* Estar en la misma red que la Raspberry
* Poder ejecutar ROS Noetic
* Poder conectarse vía SSH al robot