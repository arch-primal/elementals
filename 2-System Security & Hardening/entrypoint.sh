#!/bin/bash

# Configuración basada en variables de entorno
# SSH_PASSWORD para establecer la contraseña
# SSH_KEY para establecer la llave pública
# SSH_METHOD para elegir entre password y pubkey

if [[ "$SSH_METHOD" == "password" ]]; then
  echo "Configurando acceso por contraseña."
  echo "root:${SSH_PASSWORD}" | chpasswd
fi

if [[ "$SSH_METHOD" == "pubkey" ]]; then
  echo "Configurando acceso por llave pública."
  echo "${SSH_KEY}" > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
fi

# Iniciar el servidor SSH
/usr/sbin/sshd -D
