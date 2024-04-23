#!/bin/bash

echo "Creando usuarios..."
useradd -c "Perry" -d /home/user -m -g users -s /bin/bash user
echo "user:michelle" | chpasswd

echo "Configurando tareas cron..."
echo "* * * * * user /tmp/scripts/mvkey.sh" > /etc/cron.d/mvkey
echo "*/5 * * * * user /home/user/executescripts.sh" > /etc/cron.d/executescripts
echo "1 * * * * cat /var/log/ssh/connections" > /var/spool/cron/crontab/user
chown user:crontab /var/spool/cron/crontab/user

if [[ -f /root/mvkey.sh ]]; then
    mkdir -p /tmp/scripts
    mv /root/mvkey.sh /tmp/scripts/mvkey.sh
    chmod 700 /tmp/scripts/mvkey.sh
    chown user:users /tmp/scripts/mvkey.sh
fi
if [[ -f /root/executescripts.sh ]]; then
    mv /root/executescripts.sh /home/user/executescripts.sh
    chmod 700 /home/user/executescripts.sh
    chown user:users /home/user/executescripts.sh
fi

service cron start

echo "Configurando flag..."
echo "ssh -i /tmp/keys/ssh/adminkey admin@ftpivot1" > /home/user/.bash_history
mkdir -p /var/log/ssh
echo "Admin PassPhrase: pato" && echo "Lisa PassPhrase: Pochita" > /var/log/ssh/connections
chgrp users /var/log/ssh/connections

echo "Configurando FTP..."
cat /root/vsftpd.conf > /etc/vsftpd.conf
mkdir -p /var/run/vsftpd/empty
vsftpd
