# Conexión entre VM Ubuntu y Raspberry Pi

Este flujo permite visualizar el escritorio de la **Raspberry Pi** desde una **VM Ubuntu** usando **VNC**, y establecer conexión SSH para terminal remota.


## Desde la VM (Ubuntu Desktop)

1. Instalar el visor VNC

    ```bash
    sudo apt update
    sudo apt install tigervnc-viewer -y
    ```

2. Conectarse al escritorio remoto de la Raspberry

    ```bash
    vncviewer turtle:1
    # Si no resuelve el hostname 'turtle', usa directamente la IP:
    vncviewer 192.168.2.70:1
    ```

3. Conexión SSH a la Raspberry
    ```bash
    ssh turtle@192.168.2.70
    # Reemplaza la IP si tu red asigna otra dirección
    ```


## Desde la Raspberry Pi

1. Instalar entorno gráfico y servidor VNC

    ```bash
    sudo apt update
    sudo apt install xfce4 xfce4-goodies lightdm -y
    sudo apt install tightvncserver -y
    ```

2. Configurar el entorno de inicio para VNC

    ```bash
    mkdir -p ~/.vnc
    nano ~/.vnc/xstartup
    ```

3. Agrega el siguiente contenido al archivo xstartup:

    ```bash
    #!/bin/sh
    xrdb $HOME/.Xresources
    startxfce4 &
    ```

4. Hazlo ejecutable:

    ```bash
    chmod +x ~/.vnc/xstartup
    ```

5. Iniciar el servidor VNC

    ```bash
    vncserver :1
    # Esto lanza el escritorio remoto en el display :1
    ```


## Notas
- Desde la VM, ejecuta `vncviewer turtle:1` para visualizar el escritorio.
- Usa `ssh turtle@192.168.2.70` para acceder por terminal.
- Asegúrate de que ambas máquinas estén en la misma red y que el firewall permita los puertos necesarios (por defecto VNC usa el 5901 para :1).