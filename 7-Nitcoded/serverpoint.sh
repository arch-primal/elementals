#!/bin/bash

echo "Creando usuario..."
useradd -c "Administrator" -d /home/admin -m -g users -s /usr/bin/zsh admin
echo "root:asdffdsa" | chpasswd
echo "admin:jake" | chpasswd

echo "Configurando permisos..."
if [[ -f /home/admin/.zshrc ]]; then
  echo "__Permisos configurados previamente__"
else
  echo "admin ALL= NOPASSWD: /usr/bin/apt install *, /usr/bin/apt update, /usr/bin/apt-get install *, /usr/bin/apt-get update, /usr/bin/service *, /usr/bin/nano /etc/ssh/sshd_config, /usr/bin/nano sshd_config" >> /etc/sudoers
  echo "Defaults rootpw" >> /etc/sudoers
fi

echo "Configurando OhMyPosh..."
mv /root/themes /tmp/themes
cp /root/.zshrc /home/admin/.zshrc
chown admin:users /home/admin/.zshrc

echo "Configurando SSH..."
if [[ -d /run/sshd ]]; then
  echo "SSH configurada previamente..."
else
  mkdir -p /run/sshd
  chmod +x /tmp/command.sh
  echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
  echo "ClientAliveCountMax 1" >> /etc/ssh/sshd_config
  echo "ForceCommand /tmp/command.sh" >> /etc/ssh/sshd_config
fi
kill $(pgrep sshd)
/usr/sbin/sshd -D
