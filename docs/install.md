# Instalación Previa: Entorno de Trabajo con VM Ubuntu + Raspberry Pi

Este documento reúne los enlaces oficiales y recomendaciones para preparar el entorno base antes de conectar la VM Ubuntu con la Raspberry Pi. Asegúrate de completar estas instalaciones antes de continuar con la configuración de red, VNC o SSH.

---

## 1. Hypervisor: VMware Workstation Pro / Fusion

Para virtualizar Ubuntu Desktop en tu sistema operativo anfitrión (Windows, macOS o Linux), descarga e instala VMware desde su sitio oficial:

- [VMware Workstation y Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)

    > Usa VMware Workstation Pro si estás en Windows o Linux, y VMware Fusion si estás en macOS.

---

## 2. Imagen ISO de Ubuntu Desktop 20.04 LTS

Descarga la imagen ISO oficial de Ubuntu 20.04 LTS (Focal Fossa), ideal para estabilidad y compatibilidad con herramientas educativas:

- [Ubuntu 20.04 ISO (CDImage)](https://cdimage.ubuntu.com/releases/20.04/release/)

    > Usa la versión `ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz` para optimizar uso de recursos de la Raspberry Pi.

- [Ubuntu 20.04 ISO (Releases)](https://www.releases.ubuntu.com/focal/)

    > Usa la versión `ubuntu-20.04.6-desktop-amd64.iso` para compatibilidad con VMware y soporte extendido.

---

## 3. Raspberry Pi Imager

Para preparar la Raspberry Pi, descarga el software oficial que permite instalar sistemas operativos en una tarjeta microSD:

- [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

---

## Configuración recomendada de la imagen Raspberry Pi

Al preparar la microSD con Raspberry Pi Imager, activa las siguientes opciones antes de grabar:

### Personalización previa

- **Hostname**: `turtle`  
- **Habilitar SSH**: `True`
- **Usuario**: `turtle`  
- **Contraseña**: `turtle`  
- **Wi-Fi**:  
  - SSID: tu red local  
  - Contraseña: tu clave  
  - País: `MX` (México)


> Esto permite que la Raspberry se conecte automáticamente a la red y esté lista para SSH/VNC sin periféricos.

---

### Configuración recomendada de la máquina virtual (VM Ubuntu)

| Parámetro                  | Valor sugerido                    |
|---------------------------|------------------------------------|
| Sistema operativo         | Ubuntu 64-bit                      |
| RAM                       | 2 GB mínimo (ideal: 4 GB)          |
| Disco duro                | 20 GB mínimo (modo dinámico)       |
| Procesadores              | 2 núcleos                          |
| Adaptadores de red        | 2 (NAT + Bridged)                  |
| Modo de red NAT           | Para acceso a internet             |
| Modo de red Bridged       | Para conexión directa con Raspberry|

> El modo Bridged permite que la VM esté en la misma red que la Raspberry, facilitando SSH y VNC sin configuraciones avanzadas.

---

## ✅ Checklist de instalación

| Elemento                      | Estado esperado       |
|-------------------------------|-----------------------|
| VMware instalado              | ✅                    |
| ISO de Ubuntu descargada      | ✅                    |
| VM creada con Ubuntu Desktop  | ✅                    |
| Raspberry Pi Imager instalado | ✅                    |

---
