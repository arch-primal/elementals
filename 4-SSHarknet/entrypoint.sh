#!/bin/bash

echo "Creando usuarios..."
useradd -c "Data" -d /home/data -m -g users -s /sbin/nologin data

echo "Configurando OhMyPosh..."
chsh -s $(wich zsh) root
mv /root/themes /tmp/themes

echo "Configurando tareas cron..."
service cron start

echo "Iniciando servicio SSH..."
mkdir -p /run/sshd
/usr/sbin/sshd -D
