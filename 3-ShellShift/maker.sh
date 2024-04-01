#!/bin/bash

# Creación de usuario invitado
useradd -c "Pato" -g users -G users -d /home/user -m -s /usr/bin/zsh user
echo "user:camaro" | chpasswd

# Configuración de OhMyPosh
cp /root/.zshrc /home/user/.zshrc
cp -r /root/themes /home/user/themes

# Configuración de la Reverse Shell
mkdir -p /home/share
echo "" >> /home/share/config.txt
cp /root/reverse_shell.py /home/user/reverse_shell.py
chmod 710 /home/user/reverse_shell.py
chown root:users /home/user/reverse_shell.py

# Configuración de tareas cron
echo "*/5 * * * * user /usr/bin/python3 /home/user/reverse_shell.py" > /etc/cron.d/user-task
service cron start

# Configuración de SSH
# echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
mkdir /home/user/.ssh
touch /home/user/.ssh/authorized_keys
chown user:user /home/user/.ssh
chown user:user /home/user/.ssh/authorized_keys
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 1" >> /etc/ssh/sshd_config
kill $(pgrep sshd)
/usr/sbin/sshd -D
