#!/bin/bash

for file in {1..100}; do
  curl -T "/tmp/files/a$file" "ftp://$(cat /home/pato/serverip.txt)"

  if [ $? -ne 0 ]; then
    echo "$(date) Error al enviar el archivo a$file, deteniendo el script" >> /home/pato/sender.log
    exit 1
  fi
done

echo "$(date) Archivos enviados correctamente." >> /home/pato/sender.log
