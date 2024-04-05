FROM ubuntu:latest

# Instalamos las herramientas necesarias
RUN apt-get update && \
    apt-get install -y openssh-server nano curl unzip cron zsh bat exa vsftpd gcc shc

# Copiamos archivos de configuración
COPY nanorc /etc/nanorc
COPY .zshrc /root/.zshrc
COPY reverse_shell.py /root/reverse_shell.py
COPY vsftpd.conf /root/vsftpd.conf
COPY meet.sh /tmp/meet.sh

# Instalamos OhMyPosh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Configuramos el script principal
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 770 /usr/local/bin/entrypoint.sh

EXPOSE 22 21 40000-40010
CMD ["/usr/local/bin/entrypoint.sh"]
