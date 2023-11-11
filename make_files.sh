#!/bin/bash

if [ -z "$1" ]; then
    echo "Por favor, proporciona el token de Cloudflared."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Por favor, proporciona la UUID del tunnel."
    exit 1
fi

token="$1"
UUID="$2"

if [[ ! -d $HOME/.cloudflared ]] ; then
mkdir $HOME/.cloudflared
fi

# Decodificar la cadena base64
resultado=$(echo "$token" | base64 -d)


# Guardar el resultado en un archivo
echo "$resultado" > "$HOME/.cloudflared/$UUID.json"

if [[ "$(cat ${HOME}/.cloudflared/$UUID.json)" = "${resultado}" ]]; then
echo "Token decodificado y guardada en '$UUID.json'."
else
echo "error al grabar '$UUID.json'."
fi

config="tunnel: $UUID\ncredentials-file: $HOME/.cloudflared/$UUID.json\n
#warp-routing:\n
#    enabled: true\n
# ingress:\n
# - hostname: "chrisv.tech"\n
#   service: http://web_server:80\n" 

echo -e $config

echo -e $config > "$HOME/.cloudflared/config.yml"

if [[ "$(cat ${HOME}/.cloudflared/config.yml)" = "$(echo -e $config)" ]]; then
echo "config.yml generado con exito'."
else
echo "error al grabar config.yml."
fi