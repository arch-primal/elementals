#!/bin/bash

echo "Configurando flag..."
mkdir -p /root/files
echo "You a duck! Here your flag: $(echo 'Soy la flag' | md5sum)" > /root/flag
cat /root/flag | base64 > /root/flag.txt
rm /root/flag

base_word="test"
add_word="$(cat /root/flag.txt)"
len=${#add_word}

for (( i=0; i<$len; i++ )); do
  letter=${add_word:$i:1}
  echo $base_word$letter | base64 > "/root/files/file$i.txt"
done

echo "Configurando tarea cron..."
chmod 700 /root/sender.sh
echo "*/3 * * * * root /root/sender.sh" > /etc/cron.d/sender

tail -f /dev/null
