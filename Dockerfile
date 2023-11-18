FROM debian:bookworm

COPY --chmod=500 ./make_files.sh /usr/local/bin/

RUN /bin/bash -c 'mkdir -p --mode=0755 /usr/share/keyrings && \
apt update -y && \
apt install curl -y && \
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null && \
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main" | tee /etc/apt/sources.list.d/cloudflared.list && \
apt update && apt install cloudflared -y'

ENTRYPOINT ["make_files.sh", "$TOKEN", "$TUUID"]


# docker build . -t chrisvdev23/cloudflared:bookworm

# docker run -d -e TOKEN=$CLOUDFLARED_TOKEN -e TUUID=$CLOUDFLARED_TUNNEL_UUID chrisvdev23/cloudflared:bookworm -v /home/christian/cloudflared_network/config:/

# sobre que imagen traba
# integrar los archivos que necesita a la imagen
# ejectura los comandos para instalar cloudflared
# ENTRYPOINT ejecutar a make_file.sh pasandole argumentos el Token y luego Tunnel UUID 