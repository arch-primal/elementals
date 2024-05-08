#!/bin/bash

# Crear archivo de índice si no existe
if [ ! -f "/root/index" ]; then
  echo -n "0" > /root/index
fi

# Leer el índice actual
index=$(cat /root/index)

# Reiniciar índice si alcanza 90
if [ "$index" -eq 90 ]; then
  echo -n "0" > /root/index
fi

# Enviar 10 archivos
for i in {1..10}; do
  curl -T "/root/files/file$(($index + $i)).txt" "http://nitcoded-server:80/file$i.txt"

  if [ $? -ne 0 ]; then
    echo "$(date) - Error al enviar archivos." >> /root/sender.log
    echo -n "0" > /root/index
    exit 1
  fi
done

# Log de éxito
echo "$(date) - Archivos enviados correctamente." >> /root/sender.log

# Incrementar el índice en 10 y guardarlo
index=$(($index + 10))
echo -n $index > /root/index
