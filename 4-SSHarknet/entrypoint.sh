#!/bin/bash

echo "Creando usuarios..."
useradd -c "Data" -d /home/data -m -g users -s /usr/bin/zsh data
useradd -c "Invitado" -d /home/guest -m -g users -s /usr/bin/zsh guest
useradd -c "Admin" -d /home/admin -m -g users -s /usr/bin/zsh admin
echo "guest:winter" | chpasswd
echo "data:_winter" | chpasswd
echo "admin:_winter!" | chpasswd
cp /root/.zshrc /home/guest/.zshrc && chown guest:users /home/guest/.zshrc
cp /root/.zshrc /home/admin/.zshrc && chown admin:users /home/admin/.zshrc
cat /root/.zshrc | sed 's/amro/atomic/g' > /home/admin/.zshrc

echo "Configurando OhMyPosh..."
chsh -s $(wich zsh) root
mv /root/themes /tmp/themes

echo "Configurando FTP"
cat /root/vsftpd.conf > /etc/vsftpd.conf && rm /root/vsftpd.conf
vsftpd &

echo "Configurando tareas cron..."
#echo "0 * * * * admin ssh-keygen -t rsa -b 4096 -f /home/admin/.ssh/keygen"
service cron start

echo "Iniciando servicio SSH..."
mkdir -p /run/sshd && mkdir -p /var/run/vsftpd/empty
mkdir -p /home/guest/.ssh && chown guest:users /home/guest/.ssh
touch /home/guest/.ssh/authorized_keys && chown guest:users /home/guest/.ssh/authorized_keys
mkdir -p /home/admin/.ssh/authorized_keys && chown admin:users /home/admin/.ssh/authorized_keys
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
kill $(pgrep sshd)
/usr/sbin/sshd -D
