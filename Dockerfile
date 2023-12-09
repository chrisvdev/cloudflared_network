FROM debian:bookworm

WORKDIR /root

# COPY --chmod=500 ./make_files.sh /usr/local/bin/
COPY --chmod=500 ./init.sh /usr/local/bin/

RUN /bin/bash -c 'mkdir -p --mode=0755 /usr/share/keyrings && \
apt update -y && \
apt install curl -y && \
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null && \
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main" | tee /etc/apt/sources.list.d/cloudflared.list && \
apt update && apt install cloudflared -y'

# ENTRYPOINT ["/usr/local/bin/make_files.sh"]
ENTRYPOINT ["/usr/local/bin/init.sh"]

# sysctl -w net.core.rmem_max=4194304 && \
# sysctl -w net.core.wmem_max=4194304 && \

# docker build --no-cache . -t chrisvdev23/cloudflared:bookworm 

# para configurar -> docker run -d -e CONFIG=1 -v $PWD/data:/root/.cloudflared chrisvdev23/cloudflared:bookworm
# para ejecutar -> docker run -d -e UUID=604e356f-4589-403b-9d46-9dfe817e01c4 -v $PWD/data:/root/.cloudflared chrisvdev23/cloudflared:bookworm

# docker stop $(docker ps -a -q)

# sobre que imagen traba
# integrar los archivos que necesita a la imagen
# ejectura los comandos para instalar cloudflared
# ENTRYPOINT ejecutar a make_file.sh pasandole argumentos el Token y luego Tunnel UUID 