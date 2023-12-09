#!/bin/bash

trap 'echo "Saliendo del script"; exit' INT

contador=0

while true; do
    sleep 1
    ((contador++))
    echo "Segundos transcurridos: $contador"
done
