#!/bin/bash

if [[ -f /home/admin/key ]]; then
    rm /home/admin/key
fi

ssh-keygen -t rsa -b 4096 -f /home/admin/key -N "pato"
mkdir -p /home/admin/.ssh
cat /home/admin/key.pub > /home/admin/.ssh/authorized_keys
rm /home/admin/key.pub
