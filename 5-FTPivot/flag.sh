#!/bin/bash

echo "Mission completed! Your flag: $( echo flag | md5sum)" > /root/flag.txt
ssh-keygen -t rsa -b 4096 -f /root/kk -N ""
rm /root/kk.pub

xxd -c 16 -p kk > /root/kk.lock
xxd -c 16 -p flag.txt > /root/flag.lock
rm /root/kk /root/flag.txt

mkdir -p /etc/flag.old /etc/flag.new
chmod 700 /etc/flag.new
chmod 700 /etc/flag.old
chown guest /etc/flag.old
chown admin /etc/flag.new

cp /root/kk.lock /etc/flag.old/flag.txt
cat /root/kk.lock && /root/flag.lock > /etc/flag.new/flag.txt

chown guest /etc/flag.old/flag.txt
chown admin /etc/flag.new/flag.txt
rm /root/kk.lock /root/flag.lock
