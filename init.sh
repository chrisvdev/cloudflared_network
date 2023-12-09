#!/bin/bash

# Verifica si la variable de entorno CONFIG es igual a 1
if [ "$CONFIG" == "1" ]; then
    echo "Modo Config activado. Use 'docker exec -it indetificador_de_contenedor bash' para loguearse y configurar el nuevo tunel."

    # Función que se ejecuta en cada iteración del contador
    function contador {
        seconds=$1
        echo "$seconds: Use 'docker exec -it indentificador_de_contenedor bash' para loguearse y configurar el nuevo tunel"
    }

    # Ejecuta el contador hasta que se presione CTRL+C
    trap 'echo "Saliendo del Modo Config"; exit' INT
    seconds=0
    while true; do
        contador $seconds
        sleep 1
        ((seconds++))
    done

else
    # Verifica la existencia de archivos en las rutas especificadas
    if [ -e "/root/.cloudflared/cert.pem" ] && [ -e "/root/.cloudflared/config.yml" ] && [ -n "$(find /root/.cloudflared -name '*.json' -print -quit)" ]; then
        TUUID="$UUID"
        if [ "$TUUID" != "" ]; then
            echo "Ejecuntando cloduflared"
            cloudflared tunnel --config /root/.cloudflared/config.yml run $TUUID
        else 
            echo "Debe proporcionar la variable de entorno UUID para poder continuar"
            exit 1
        fi
    else
        echo "Revise que ya tiene los archivos configurados para poder arrancar el contenedor y que monto bien el volumen"
        exit 1
    fi
fi
