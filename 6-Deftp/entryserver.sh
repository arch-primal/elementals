#!/bin/bash

echo "Creando usuario administrador..."
useradd -c "Admin" -d /home/admin -m -s /usr/bin/zsh admin
echo "admin:spider" | chpasswd
echo "root:asdfasdf" | chpasswd

echo "Configurando permisos..."
if [[ -f /home/admin/.zshrc ]]; then
  echo "__Permisos configurados previamente__"
else
  echo "admin ALL= NOPASSWD: /usr/bin/apt-get install vsftpd, /usr/bin/apt-get update, /usr/bin/nano -R /etc/vsftpd.conf, /usr/bin/nano -R vsftpd.conf, /usr/sbin/vsftpd, /usr/sbin/service *" >> /etc/sudoers
  echo "Defaults rootpw" >> /etc/sudoers
  mkdir -p /var/run/vsftpd/empty
fi

mkdir -p /etc/cron.d
echo "* * * * * admin curl http://diftp-client" > /etc/cron.d/request

echo "Configurando ZSH..."
mv /root/themes /tmp/themes
cp /root/.zshrc /home/admin/.zshrc
chown admin:admin /home/admin/.zshrc

echo "Configurando de SSH..."
mkdir -p /run/sshd
kill $(pgrep sshd)
/usr/sbin/sshd -D
