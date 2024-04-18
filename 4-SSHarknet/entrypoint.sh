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
cp /root/.zshrc /home/data/.zshrc && chown data:users /home/data/.zshrc
cat /root/.zshrc | sed 's/amro/atomic/g' > /home/data/.zshrc

echo "Configurando OhMyPosh..."
chsh -s $(which zsh) root
mv /root/themes /tmp/themes

echo "Configurando FTP..."
cat /root/vsftpd.conf > /etc/vsftpd.conf
vsftpd &

echo "Configurando capabilities..."
setcap cap_net_raw+ep /usr/bin/tcpdump

echo "Configurando tareas cron..."
mv /root/createkey.sh /home/data/createkey.sh
mv /root/initserver.py /home/data/initserver.py
mv /root/backup.sh /home/admin/backup.sh
chmod 700 /home/data/createkey.sh
chmod 700 /home/data/initserver.py
chmod 700 /home/admin/backup.sh
chown data:backup /home/data/createkey.sh
chown data:backup /home/data/initserver.py
chown admin:shadow /home/admin/backup.sh
echo "@reboot data /home/data/createkey.sh" >> /etc/cron.d/createsshkey
echo "@reboot data python3 /home/data/initserver.py" >> /etc/cron.d/startserverhttp
echo "*/5 * * * * admin /home/admin/backup.sh" >> /etc/cron.d/backup
service cron start

echo "Ocultando la flag..."
mkdir -p /tmp/backup/important
echo "Ere to' un capo, you got me\!" | base64 > /tmp/backup/important/flag.txt
chmod 400 /tmp/backup/important/flag.txt
chown data:backup /tmp/backup/important/flag.txt

echo "Iniciando servicio SSH..."
mkdir -p /run/sshd && mkdir -p /var/run/vsftpd/empty
mkdir -p /home/guest/.ssh && chown guest:users /home/guest/.ssh
touch /home/guest/.ssh/authorized_keys && chown guest:users /home/guest/.ssh/authorized_keys
mkdir -p /home/data/.ssh && chown data:users /home/data/.ssh
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
kill $(pgrep sshd)
/usr/sbin/sshd -D
