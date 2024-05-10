#!/bin/bash

# Crear archivo de índice si no existe
if [ ! -f "/root/index" ]; then
  echo -n "0" > /root/index
fi

# Leer el índice actual
index=$(cat /root/index)

# Reiniciar índice si alcanza 90
if (( "$index" >= 90 )); then
  echo -n "0" > /root/index
  echo "$(date) - Todos los archivos fueron enviados." >> /root/sender.log
  exit 1
fi

# Enviar 10 archivos
for i in {0..9}; do
  if [[ ! -f "/root/files/file$(($index + $i)).txt" ]]; then
    echo "$(date) - Archivo file$(($index + $i)).txt no encontrado." >> /root/sender.log
  fi

  curl -T "/root/files/file$(($index + $i)).txt" "http://localhost:80/file$i.txt" 2>/dev/null

  if [ $? -ne 0 ]; then
    echo "$(date) - Error al enviar archivos. Reiniciando envío." >> /root/sender.log
    echo -n "0" > /root/index
    exit 1
  else
    echo "$(date) - Archivo file$(($index + $i)).txt enviado correctamente." >> /root/sender.log
  fi
done

# Incrementar el índice en 10 y guardarlo
index=$(($index + 10))
echo -n $index > /root/index
