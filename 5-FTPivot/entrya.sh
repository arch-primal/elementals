#!/bin/bash

echo "Creando usuarios..."
useradd -c "Perry" -d /home/admin -m -g users -s /usr/bin/zsh admin
useradd -c "Pato" -d /home/guest -m -g users -s /usr/bin/zsh guest
echo "guest:pepper" | chpasswd
echo "admin:michelle" | chpasswd

echo "Condigurando capabilities"
setcap cap_net_raw+ep /usr/bin/tcpdump

echo "Configurando OhMyPosh..."
mv /root/themes /tmp/themes
chsh -s $(which zsh) root
chsh -s $(which zsh) admin
chsh -s $(which zsh) guest
cp /root/.zshrc /home/guest/.zshrc && chown guest:users /home/guest/.zshrc
cp /root/.zshrc /home/admin/.zshrc && chown admin:users /home/guest/.zshrc

echo "Configurando tareas cron..."
echo "@reboot /root/flag.sh" > /var/spool/cron/crontabs/root
chmod 700 /root/flag.sh
chmod 600 /var/spool/cron/crontabs/root
chgrp crontab /var/spool/cron/crontabs/root
echo "@reboot admin /home/admin/createkey.sh" > /etc/cron.d/createkey
echo "*/6 * * * * admin /home/admin/senderkey.sh" > /etc/cron.d/sendkey

if [[ -f /root/createkey.sh ]]; then
    mv /root/createkey.sh /home/admin/createkey.sh
    chmod 700 /home/admin/createkey.sh
    chown admin:users /home/admin/createkey.sh
fi

if [[ -f /root/senderkey.sh ]]; then
    mv /root/senderkey.sh /home/admin/senderkey.sh
    chmod 700 /home/admin/senderkey.sh
    chown admin:users /home/admin/senderkey.sh
fi
service cron start

echo "Configurando SSH..."
mkdir -p /run/sshd

if [[ -f /root/sshd_config ]]; then
    cat /root/sshd_config >> /etc/ssh/sshd_config
    rm /root/sshd_config
fi

kill $(pgrep sshd)
/usr/sbin/sshd -D
