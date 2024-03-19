#!/bin/bash

# Define la ruta a la carpeta con los scripts
CARPETA="/home/.user/scripts"

# Ejecuta todos los scripts .sh encontrados en la carpeta
for script in "${CARPETA}"/*.sh; do
    if [ -f "$script" ]; then
        bash "$script"
    fi
done

# Limpia la carpeta después de ejecutar los scripts
rm -rf "${CARPETA}"/*

echo "Scripts ejecutados: $(date)"
