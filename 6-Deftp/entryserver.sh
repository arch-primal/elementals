#!/bin/bash

echo "Creando usuario administrador..."
useradd -c "Admin" -d /home/admin -m -s /usr/bin/zsh admin
echo "admin:spider" | chpasswd

echo "Configurando permisos..."
if [[ -f /home/admin/.zshrc ]]; then
  echo "__Permisos configurados previamente__"
else
  echo "admin ALL= NOPASSWD: /usr/bin/apt-get install *, /usr/bin/nano /etc/vsftpd.conf, /usr/bin/nano vsftpd.conf, /usr/sbin/vsftpd" >> /etc/sudoers
  mkdir -p /var/run/vsftpd/empty
fi

echo "Configurando ZSH..."
mv /root/themes /tmp/themes
cp /root/.zshrc /home/admin/.zshrc
chown admin:admin /home/admin/.zshrc

echo "Configurando de SSH..."
mkdir -p /run/sshd
kill $(pgrep sshd)
/usr/sbin/sshd -D
