#!/bin/bash

if [ -z "$TOKEN" ]; then
  echo "Por favor, proporciona el token de Cloudflared."
  exit 1
else 
  echo "Se recibio el Token..."
fi

if [ -z "$TUUID" ]; then
  echo "Por favor, proporciona la UUID del tunnel."
  exit 1
else 
  echo "Se recibio el Token..."
fi

token="$TOKEN"
UUID="$TUUID"

if [[ ! -d $HOME/.cloudflared ]]; then
  mkdir $HOME/.cloudflared
fi

# Decodificar la cadena base64
resultado=$(echo "$token" | base64 -d)

# Guardar el resultado en un archivo
if [[ ! -f $HOME/.cloudflared/$UUID.json ]]; then
  echo "$resultado" > "$HOME/.cloudflared/$UUID.json" 
  if [[ "$(cat ${HOME}/.cloudflared/$UUID.json)" = "${resultado}" ]]; then
    echo "Token decodificado y guardada en '$UUID.json'."
  else
    echo "Error al grabar '$UUID.json'."
    exit 1
  fi
else 
  echo "Ya existe el archivo $UUID.json ..."
fi

# Creando el contenido del archivo de configuracion
config="tunnel: $UUID\ncredentials-file: $HOME/.cloudflared/$UUID.json\n\ningress:\n  - hostname: "chrisv.tech"\n    service: http://web_server:80\n" 

# Guardando el resultado en un archivo
if [[ ! -f $HOME/.cloudflared/config.yml ]]; then
  echo -e $config > "$HOME/.cloudflared/config.yml"
  if [[ "$(cat ${HOME}/.cloudflared/config.yml)" = "$(echo -e $config)" ]]; then
    echo "config.yml generado con exito'."
  else
    echo "error al grabar config.yml."
    exit 1
  fi
else
  echo "Ya existe el archivo config.yml"
fi

echo "ejecutando cloudflared para conectarse al tunel ..."
cloudflared tunnel --config $HOME/.cloudflared/config.yml run $UUID