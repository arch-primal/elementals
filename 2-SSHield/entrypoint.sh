#!/bin/bash
# KEY = Variable de entorno que determina si la conexión es por contraseña o por llave pública

if [[ "$KEY" == "" ]]; then
  echo "Configurando acceso por llave pública."

  # Verifica que no exista la llave creada
  # Por si otro contenedor ya fue lanzado
  if [ ! -f "/keys/key.pub" ]; then
    ssh-keygen -t rsa -b 4096 -f /keys/key -N ""
  fi

  mkdir -p  /root/.ssh
  touch /root/.ssh/authorized_keys
  cat /keys/key.pub >> /root/.ssh/authorized_keys

  chmod 700 /root/.shh
  chmod 600 /root/.ssh/authorized_keys
else
  echo "Configurando acceso por contraseña."
  echo "root:${KEY}" | chpasswd
  echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
fi

# Iniciar el servidor SSH
/usr/sbin/sshd -D
