#!/bin/bash
# KEY = Variable de entorno que determina si la conexión es por contraseña o por llave pública
# USR = Variable d entorno para crear el usuario al que se conectarán por SSH

echo "Configurando contraseña de root..."
echo "root:$(echo -n asdf | base64)" | chpasswd

# Creamos el usuario
if [[ "$USR" == "" ]]; then
  # Por defecto coloca al usuario root
  unset USR
  export USR="root"
else
  echo "Creando usuario..."
  useradd -c "Pato" -g users -d "/home/${USR}" -m -s /usr/bin/zsh "${USR}"
fi

# Obtenemos la carpeta del usuario
UserPath=$(mktemp)
echo "Obteniendo la carpeta de usuario..."
if [[ "$USR" == "root" ]]; then
  echo "/root" >> $UserPath
else
  echo "/home/${USR}" >> $UserPath
fi

if [[ "$KEY" == "" ]]; then
  echo "Configurando acceso por llave pública..."

  # Verifica que no exista la llave creada
  # Por si otro contenedor ya fue lanzado
  if [ ! -f "/keys/key.pub" ]; then
    ssh-keygen -t rsa -b 4096 -f /keys/key -N ""
  fi

  # Crea las configuraciones para las llaves públicas
  mkdir -p "$(cat $UserPath)/.ssh"
  touch "$(cat $UserPath)/.ssh/authorized_keys"
  cat /keys/key.pub >> "$(cat $UserPath)/.ssh/authorized_keys"

  chmod 700 "$(cat $UserPath)/.shh"
  chmod 600 "$(cat $UserPath)/.ssh/authorized_keys"
  echo "Llave pública configurada correctamente"
else
  echo "Configurando acceso por contraseña..."
  echo "${USR}:${KEY}" | chpasswd

  # Permitimos conexiones por contraseña
  echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
  if [[ "$USR" == "root" ]]; then
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
  fi
  echo "Contraseña configurada correctamente"
fi

# Configuramos OhMyPosh
echo "Configurando OhMyPosh..."
cp /root/.zshrc /home/.user/.zshrc
cp -r /root/themes /home/.user/themes

if [[ "$USR" != "root" ]]; then
  cp -r /root/themes "$(cat $UserPath)/themes"
  cat /root/.zshrc > "$(cat $UserPath)/.zshrc"
fi

# Configuramos el archivo secreto
echo "Hiding secrets..."
chmod 660 /home/.user/.secret
chown .user /home/.user/.secret
mkdir /home/.user/scripts
chmod 777 /home/.user/scripts
chown .user /home/.user/scripts

# Configuramos las tareas cron
echo "Configurando tareas cron..."
chmod 774 /home/.user/task.sh
chown .user /home/.user/task.sh
(crontab -u root -l; echo "* * * * * su - .user -c '/home/.user/task.sh'") | crontab -u root -
service cron start

rm $UserPath

# Iniciar el servidor SSH
echo "Iniciando el servidor SSH..."
/usr/sbin/sshd -D
