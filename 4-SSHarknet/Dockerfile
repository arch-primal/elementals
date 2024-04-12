FROM ubuntu:latest

RUN \
	apt-get update && apt-get install -y \
	curl cron openssh-server unzip tcpdump exa bat vsftpd zsh

# Instalación OhMyPosh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s
COPY .zshrc /root/.zshrc

# EXPOSE 100-101

# Configuración de script principal
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 770 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
