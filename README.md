# 🇬🇧 In English...

# Setting up Cloudflare Tunnel using Docker

This repository contains instructions for configuring and using the Docker image "chrisvdev23/cloudflared" to manage a Cloudflare tunnel.

## Container Description

The container contains the `cloudflared` command, which is provided by Cloudflare as a client to connect and manage tunnel services.

The container has two modes of operation, depending on the existence of an environment variable called `UUID`. This variable refers to the UUID of the configured tunnel. If the `UUID` variable does not exist, the container will enter "config" mode. In this mode, you can access an interactive terminal to configure your tunnel. If the `UUID` variable exists, the container will enter normal mode and use the generated files and variable to manage and connect to the tunnel.

It is necessary to mount a volume to the image to persist the content of the "/root/.cloudflared" directory.

## Steps to Configure the Container in "config" mode

1. Enter the container using the following Docker command: `docker exec -it <id_or_name_of_container> bash`.
2. Execute the command inside the container: `cloudflared tunnel login`. Follow the prompts to log in the client with Cloudflare.
3. Create the tunnel with the command: `cloudflared tunnel create <NAME or UUID>`. If you have previously created the tunnel and need to regenerate the files, you will have to delete the previous tunnel with the command: `cloudflared tunnel delete <NAME or UUID>`. You can list the tunnels with the command: `cloudflared tunnel list`.
4. Exit the interactive terminal of the container and, within the mounted folder at "/root/.cloudflared", create the `services.json` file with the required format. An example of this file can be found in `services.json.example` to correctly run the container.

That's it! Now you can use the Docker image "chrisvdev23/cloudflared" to manage your Cloudflare tunnel.


# 🇪🇸 En Español... 

# Configuración del túnel de Cloudflare usando Docker

Este repositorio contiene instrucciones para configurar y usar la imagen de Docker "chrisvdev23/cloudflared" para gestionar un túnel de Cloudflare.

## Descripción del contenedor

El contenedor contiene el comando `cloudflared`, que es proporcionado por Cloudflare como cliente para conectarse y gestionar los servicios de túneles.

El contenedor tiene dos modos de funcionamiento, que se ejecutan dependiendo de si existe una variable de entorno llamada `UUID`. Esta variable hace referencia al UUID del túnel que se haya configurado. Si la variable `UUID` no existe, el contenedor entrará en modo "config". En este modo, se puede acceder a través de una terminal interactiva para configurar el túnel. Si la variable `UUID` existe, el contenedor entrará en modo normal y utilizará los archivos generados y la variable para gestionar y conectarse al túnel.

Es necesario montar un volumen en la imagen para persistir el contenido de la dirección "/root/.cloudflared".

## Pasos para configurar el contenedor en modo "config"

1. Entrar al contenedor con el siguiente comando de Docker: `docker exec -it <id_or_name_of_container> bash`.
2. Ejecutar dentro del contenedor el comando: `cloudflared tunnel login`. Seguir las indicaciones para iniciar sesión con Cloudflare.
3. Crear el túnel con el comando: `cloudflared tunnel create <NAME or UUID>`. Si ya se ha creado el túnel anteriormente y se necesitan generar los archivos nuevamente, se debe eliminar el túnel anterior con el comando: `cloudflared tunnel delete <NAME or UUID>`. Se puede listar los túneles con el comando: `cloudflared tunnel list`.
4. Salir de la terminal interactiva del contenedor y, dentro de la carpeta que se haya montado en "/root/.cloudflared", crear el archivo `services.json` con el formato requerido. Un ejemplo de este archivo se encuentra en `services.json.example` para ejecutar el contenedor correctamente.

¡Listo! Ahora puedes usar la imagen de Docker "chrisvdev23/cloudflared" para gestionar tu túnel de Cloudflare.