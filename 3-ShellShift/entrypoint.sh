#!/bin/bash

# Creación de usuario invitado
echo "Creando usuario..."
useradd -c "Pato" -g users -G users -d /home/guest -m -s /usr/bin/zsh guest
echo "guest:camaro" | chpasswd

# Configuración de OhMyPosh
echo "Configurando OhMyPosh..."
cp /root/.zshrc /home/guest/.zshrc
cp -r /root/themes /home/guest/themes

# Configuración FTP
echo "Configurando FTP..."
cat /root/vsftpd.conf > /etc/vsftpd.conf
mkdir -p /var/run/vsftpd/empty
mkdir /home/guest/ips
chmod 777 /home/guest/ips
vsftpd &

# Configuración Flag
shc -f /tmp/meet.sh
rm /tmp/meet.sh && rm /tmp/meet.sh.x.c
chmod 111 /tmp/meet.sh.x

# Configuración de la Reverse Shell
echo "Configurando Reverse Shell..."
mkdir -p /home/share
echo "" >> /home/share/config.txt
cp /root/reverse_shell.py /home/guest/reverse_shell.py
chmod 750 /home/guest/reverse_shell.py
chown root:users /home/guest/reverse_shell.py
chmod 711 /tmp/meet.sh.x

# Configuración de tareas cron
echo "Programando tareas..."
echo "*/5 * * * * guest python3 /home/guest/reverse_shell.py" > /etc/cron.d/user-task
service cron start

# Configuración de SSH
echo "Configurando SSH..."
mkdir /home/guest/.ssh
mkdir -p /run/sshd && sudo chmod 755 /run/sshd
chmod 000 /home/guest/.ssh
touch /home/guest/.ssh/authorized_keys
chown guest:users /home/guest/.ssh
chown guest:users /home/guest/.ssh/authorized_keys
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 1" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
kill $(pgrep sshd)
/usr/sbin/sshd -D
