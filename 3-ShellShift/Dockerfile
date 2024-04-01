FROM ubuntu:latest

# Instalamos las herramientas necesarias
RUN apt-get update && \
    apt-get install -y openssh-server nano curl unzip cron zsh bat exa netcat

# Copiamos archivos de configuración
COPY nanorc /etc/nanorc
COPY .zshrc /root/.zshrc
COPY reverse_shell.py /root/reverse_shell.py

# Instalamos OhMyPosh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Configuramos el script principal
COPY maker.sh /usr/local/bin/maker.sh
RUN chmod +x /usr/local/bin/maker.sh && mkdir /run/sshd

EXPOSE 22
CMD ["/usr/local/bin/maker.sh"]
