#!/bin/bash

# set -x

echo -e "╔════════════════════════════════════════════════════════════════════════════╗\n║   Custom "Cloudflared" container for Cloudflare Tunnel made by /ChrisVDev    ║\n║                    and the community for the community.                    ║\n║                                                                            ║\n║                              Version: 1.0.0                                ║\n╚════════════════════════════════════════════════════════════════════════════╝"

echo "Verifying configuration..."

# Verifica si la variable de entorno CONFIG es igual a 1
TUUID="$UUID"
if [ "$TUUID" != "" ]; then
    # Verifica la existencia de archivos en las rutas especificadas
    if [ -e "/root/.cloudflared/cert.pem" ] && [ -n "$(find /root/.cloudflared -name '*.json' -print -quit)" ]; then
        if [ -e "/root/.cloudflared/services.json" ]; then
            if [ -e "/root/.cloudflared/config.yml" ]; then
                rm /root/.cloudflared/config.yml
            fi
            services_file="/root/.cloudflared/services.json"
            services=$(jq length "$services_file")
            if [ "$services" == "0" ]; then
                echo -e "There are no services registered in services.json...\nYou need to set up at least one to run the container..."
                exit 1
            fi
            config="tunnel: $TUUID\ncredentials-file: $HOME/.cloudflared/$UUID.json\n\ningress:\n"
            for ((i=0; i<services; i++)); do
                domain=$(jq -r ".[$i].domain" "$services_file")
                service=$(jq -r ".[$i].to" "$services_file")
                config+="  - hostname: $domain\n    service: $service\n"
                echo "Registering $domain on Cloudflare's DNS servers"
                cloudflared tunnel route dns $TUUID $domain
            done
            config+="  - service: http_status:404\n"
            echo -e "$config" > "$HOME/.cloudflared/config.yml"
            cloudflared tunnel --config /root/.cloudflared/config.yml run $TUUID
        else
            echo "Create the services.json file so you can continue..."
            exit 1    
        fi
    else
        echo "Check that you are logged in and configure the new tunnel correctly to continue..."
        exit 1
    fi
else
    echo -e "A UUID has not been provided. Config mode activated.\nUse 'docker exec -it id_or_name_of_container bash' to log in and configure the new tunnel."

    # Función que se ejecuta en cada iteración del contador
    function contador {
        seconds=$1
        echo "$seconds: Use 'docker exec -it id_or_name_of_container bash' to log in and configure the new tunnel."
    }

    # Ejecuta el contador hasta que se presione CTRL+C
    trap 'echo "Exiting Config Mode"; exit' INT
    seconds=0
    while true; do
        contador $seconds
        sleep 1
        ((seconds++))
    done

fi         