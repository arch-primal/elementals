#!/bin/sh

# Limpiar reglas existentes
nft flush ruleset

# Crear tabla y cadenas
nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; }
nft add chain inet filter forward { type filter hook forward priority 0 \; }
nft add chain inet filter output { type filter hook output priority 0 \; }

# Reglas básicas
## Tráfico loopback y conexiones establecidas
nft add rule inet filter input iif lo accept
nft add rule inet filter input ct state established,related accept

## Limita nuevas conexiones
nft add rule inet filter input tcp dport { 80, 443 } ct state new limit rate 25/second accept
nft add rule inet filter input udp dport { 80, 443 } limit rate 25/second accept

## Limita paquetes ICMP
nft add rule inet filter input icmp type echo-request limit rate 5/second accept
nft add rule inet filter input icmp type echo-reply limit rate 5/second accept

## Bloquea tráfico restante
nft add rule inet filter input drop

# Listar reglas para verificar
nft list ruleset
