FROM debian:bookworm

WORKDIR /root

# install cloudflared

RUN /bin/bash -c 'apt update -y && \
apt upgrade -y && \
apt install wget jq -y && \
wget https://github.com/cloudflare/cloudflared/releases/download/2025.2.0/cloudflared-linux-amd64.deb && \
apt remove wget -y && \
apt autoremove -y && \
apt clean && \
dpkg -i cloudflared-linux-amd64.deb && \
rm cloudflared-linux-amd64.deb'

# create flare user for a secure execution and inject the init script

RUN /bin/bash -c 'groupadd --system --gid 666 cloud && \
adduser --system --uid 666 flare --gid 666 && \
mkdir -p /home/flare/ && \
chown flare:cloud /home/flare/ && \
mkdir -p /home/flare/.cloudflared && \
chown flare:cloud /home/flare/.cloudflared'

USER flare

WORKDIR /home/flare

COPY --chown=flare:cloud --chmod=500 ./init.sh /home/flare/

ENV HOME=/home/flare

ENTRYPOINT ["/home/flare/init.sh"]

# docker build --no-cache . -t chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm 

# para configurar -> docker run -d -v $PWD/data:/home/flare/.cloudflared:rw chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm
# para ejecutar -> docker run -d -e UUID=604e356f-4589-403b-9d46-9dfe817e01c4 -v $PWD/data:/root/.cloudflared:rw -u flare:cloud chrisvdev23/cloudflared:1.1.0-2025.2.0-bookworm

# docker stop $(docker ps -a -q) 