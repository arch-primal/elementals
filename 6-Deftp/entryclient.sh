#!/bin/bash

echo "Creando usuario..."
useradd -c "Pato" -d /home/pato -m -g users -s /bin/bash pato

echo "Configurando tareas cron..."
echo "deftp-server" > /home/pato/serverip.txt
echo "Good job! Your flag: $(echo flag | base64)" > /tmp/flag
mkdir -p /tmp/files
chown pato:users /tmp/files

for file in {1..100}; do
  echo "test$file" | base64 > "/tmp/files/a$file"
  chown pato:users "/tmp/files/a$file"
done

cat /tmp/flag | base64 > /tmp/files/a69
rm /tmp/flag

chown pato:users /home/pato/serverip.txt
chown pato:users /tmp/flag.txt
chown pato:users /tmp/sender.sh
chmod 700 /tmp/sender.sh
echo "*/5 * * * * pato /tmp/sender.sh" > /etc/cron.d/senderflag
service cron start

echo "Condigurando servidor HTTP..."
cp /root/httpserver.py /tmp/httpserver.py
chmod 700 /tmp/httpserver.py
chown pato:users /tmp/httpserver.py
sudo -u pato python3 /tmp/httpserver.py
