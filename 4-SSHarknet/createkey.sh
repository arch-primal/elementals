#!/bin/bash

# Data
if [[ -f "/home/data/key" ]]; then
    rm /home/data/key
fi

# Creación de llave ssh
ssh-keygen -t rsa -b 4096 -f /home/data/key -N ""
cat /home/data/key.pub > /home/data/.ssh/authorized_keys
rm /home/data/key.pub

# Encriptación de llave ssh
tar -czf /home/data/key.tar.gz /home/data/key
rm /home/data/key
xxd -c 16 -p /home/data/key.tar.gz > /home/data/key
rm /home/data/key.tar.gz
