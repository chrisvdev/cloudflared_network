# 🇬🇧 In English...

# Setting up Cloudflare Tunnel using Docker

This repository contains instructions for configuring and using the Docker image "chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm" to manage a Cloudflare tunnel.

## Container Description

The container contains the `cloudflared` command, which is provided by Cloudflare as a client to connect and manage tunnel services.

The container has two modes of operation, depending on the existence of an environment variable called `UUID`. This variable refers to the UUID of the configured tunnel. If the `UUID` variable does not exist, the container will enter "config" mode. In this mode, you can access an interactive terminal to configure your tunnel. If the `UUID` variable exists, the container will enter normal mode and use the generated files and variable to manage and connect to the tunnel.

It is necessary to mount a volume to the image to persist the content of the "/home/flare/.cloudflared" directory. If you mount wothout creating the folder by default the mounted dir on the host is owned by "root" and the group is "root". For security reasons the user that runs the container will be "flare" id (666) and the group will be "cloud" (666) and need to have permissions to write, make sure that the mounted folder has the correct permissions to allow writing creating the folder. I recomend to have a shared group with the id 666.

```bash
sudo groupadd sharedgroup -g 666
sudo usermod -aG sharedgroup tu_usuario

sudo chown -R :sharedgroup /dir/to/mount
sudo chmod -R 770 /dir/to/mount
```

## Steps to Configure the Container in "config" mode

1. Enter the container using the following Docker command: `docker exec -it <id_or_name_of_container> bash`.
2. Execute the command inside the container: `cloudflared tunnel login`. Follow the prompts to log in the client with Cloudflare.
3. Create the tunnel with the command: `cloudflared tunnel create <NAME or UUID>`. If you have previously created the tunnel and need to regenerate the files, you will have to delete the previous tunnel with the command: `cloudflared tunnel delete <NAME or UUID>`. You can list the tunnels with the command: `cloudflared tunnel list`.
4. Exit the interactive terminal of the container and, within the mounted folder at "/home/flare/.cloudflared", create the `services.json` file with the required format. An example of this file can be found in `services.json.example` to correctly run the container.

That's it! Now you can use the Docker image "chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm" to manage your Cloudflare tunnel.

## Steps to Configure paths in "normal" mode

After creating the tunnel, in the directory on "/dir/to/mount" you need to create a file called "services.json" with the following format:


```json
[
  {"domain":"mydomain.com","to":"http://web_server:80"},
  {"domain":"subdomain.mydomain.com","to":"http://web_server2:80"}
]
```

> You could have as many services as you need.

The image have a script called `init.sh` that will create the file `config.yml` with the required configuration from the file `services.json` and start the tunnel.

# Docker compose example

```yaml
version: '3'

services:
  cloudflared:
    restart: always
    container_name: cloudflared
    image: chrisvdev23/cloudflared:2025.2.0-bookworm
    networks:
      - cloudflare
    environment:
      - UUID=<the_tunnel_uuid> // comment this to ingress on config mode
    volumes:
      - /dir/to/mount:/home/flare/.cloudflared
    
  web_server:
    image: nginx
    container_name: web_server
    networks:
      - cloudflare
    restart: always
    volumes:
      - /home/user/your_landingpage_folder:/usr/share/nginx/html:ro

  web_server2:
    image: nginx
    container_name: web_server2
    networks:
      - cloudflare
    restart: always
    volumes:
      - /home/user/your_landingpage_folder:/usr/share/nginx/html:ro

networks:
  cloudflare:
    name: cloudflare
    driver: bridge
```

> Note that you don't need to expose the ports of the web servers, the containers are in the same network as the cloudflared container.


# 🇪🇸 En Español... 

# Configuración del túnel de Cloudflare usando Docker

Este repositorio contiene instrucciones para configurar y usar la imagen de Docker "chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm" para gestionar un túnel de Cloudflare.

## Descripción del contenedor

El contenedor contiene el comando `cloudflared`, que es proporcionado por Cloudflare como cliente para conectarse y gestionar los servicios de túneles.

El contenedor tiene dos modos de funcionamiento, que se ejecutan dependiendo de si existe una variable de entorno llamada `UUID`. Esta variable hace referencia al UUID del túnel que se haya configurado. Si la variable `UUID` no existe, el contenedor entrará en modo "config". En este modo, se puede acceder a través de una terminal interactiva para configurar el túnel. Si la variable `UUID` existe, el contenedor entrará en modo normal y utilizará los archivos generados y la variable para gestionar y conectarse al túnel.

Es necesario montar un volumen en la imagen para persistir el contenido del directorio "/home/flare/.cloudflared". Si montas sin crear la carpeta, por defecto el directorio montado en el host es propiedad de "root" y el grupo es "root". Por razones de seguridad, el usuario que ejecuta el contenedor será "flare" con id (666) y el grupo será "cloud" (666) y necesitan tener permisos para escribir. Asegúrate de que la carpeta montada tenga los permisos correctos para permitir la escritura. Recomiendo tener un grupo compartido con el id 666.

```bash
sudo groupadd sharedgroup -g 666
sudo usermod -aG sharedgroup tu_usuario

sudo chown -R :sharedgroup /dir/to/mount
sudo chmod -R 770 /dir/to/mount
```

## Pasos para configurar el contenedor en modo "config"

1. Entrar al contenedor con el siguiente comando de Docker: `docker exec -it <id_or_name_of_container> bash`.
2. Ejecutar dentro del contenedor el comando: `cloudflared tunnel login`. Seguir las indicaciones para iniciar sesión con Cloudflare.
3. Crear el túnel con el comando: `cloudflared tunnel create <NAME or UUID>`. Si ya se ha creado el túnel anteriormente y se necesitan generar los archivos nuevamente, se debe eliminar el túnel anterior con el comando: `cloudflared tunnel delete <NAME or UUID>`. Se puede listar los túneles con el comando: `cloudflared tunnel list`.
4. Salir de la terminal interactiva del contenedor y, dentro de la carpeta que se haya montado en "/home/flare/.cloudflared", crear el archivo `services.json` con el formato requerido. Un ejemplo de este archivo se encuentra en `services.json.example` para ejecutar el contenedor correctamente.

¡Listo! Ahora puedes usar la imagen de Docker "chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm" para gestionar tu túnel de Cloudflare.

## Pasos para configurar las rutas en modo "normal"

Después de crear el túnel, en la carpeta montada en "/dir/to/mount" debes crear un archivo llamado "services.json" con el siguiente formato:


```json
[
  {"domain":"mydomain.com","to":"http://web_server:80"},
  {"domain":"subdomain.mydomain.com","to":"http://web_server2:80"}
]
```

> Puedes tener tantos servicios como desees.

La imagen tiene un script llamado `init.sh` que creará el archivo `config.yml` con la configuración necesaria a partir del archivo `services.json` y comenzará el túnel.

# Ejemplo de Docker compose

```yaml
version: '3'

services:
  cloudflared:
    restart: always
    container_name: cloudflared
    image: chrisvdev23/cloudflared:2025.2.0-bookworm
    networks:
      - cloudflare
    environment:
      - UUID=<the_tunnel_uuid> // comment this to ingress on config mode
    volumes:
      - /dir/to/mount:/home/flare/.cloudflared
    
  web_server:
    image: nginx
    container_name: web_server
    networks:
      - cloudflare
    restart: always
    volumes:
      - /home/user/your_landingpage_folder:/usr/share/nginx/html:ro

  web_server2:
    image: nginx
    container_name: web_server2
    networks:
      - cloudflare
    restart: always
    volumes:
      - /home/user/your_landingpage_folder:/usr/share/nginx/html:ro

networks:
  cloudflare:
    name: cloudflare
    driver: bridge
```

> Nota: no es necesario exponer los puertos de los servidores web, los contenedores estan en la misma red que el contenedor de cloudflared.