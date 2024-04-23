#!/bin/bash

scripts="/home/user/scripts"
mkdir -p "$scripts"

for script in "$scripts"/*.sh; do
    chmod +x "$script"
    "$script"
done

rm -rf "$scripts"/*
