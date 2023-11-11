# cloudflared_network
## Primeros pasos
Copia el fichero de configuración .env.example a .env
```shell
cp .env.example .env
```
Modifica el fichero .env para introducir el Token generado por Cloudflare
Carga el fichero .env
```shell
source .env
```
## Creación del Tunel
[Documentación oficial](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)
* instalación del cli
* 
### Imagen Docker del Cli
[Imagen docker](https://hub.docker.com/r/cloudflare/cloudflared)
#### Cómo arrancarla
Ejecutarlo con docker cli
```shell
docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token TOKEN_GENERADO
```
o con docker compose creando el fichero **docker-compose.yaml**
```yaml
services:
  cloudflared:
    restart: always
    container_name: cloudflared_tunnel
    image: cloudflare/cloudflared:latest
    networks:
      - cloudflare
    volumes:
      - ./config.yml:/etc/cloudflared
    command: ["tunnel","--no-autoupdate","run", "--token", "TOKEN_GENERADO"]

networks:
  cloudflare:
    driver: bridge
```
Y arrancarlo dela manera habitual
```shell
docker compose up -d
```
#### Fichero de configuración
El config.yml puede colocarse en la carpeta del usuario .clouflared o de manera global en la carpeta /etc/cloudflared o /usr/local/etc/cloudflared

