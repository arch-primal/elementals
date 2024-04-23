#!/bin/bash

if [[ -f /home/user/adminkey ]]; then
    mkdir -p /tmp/keys/ssh
    mv /home/user/adminkey /tmp/keys/ssh
fi
