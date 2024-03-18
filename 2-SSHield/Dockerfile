FROM ubuntu:latest

# Evitar preguntas al instalar paquetes
ARG DEBIAN_FRONTEND=noninteractive

# Actualizar repositorios e instalar OpenSSH Server y la zsh
RUN apt-get update && apt-get install -y openssh-server zsh curl unzip sudo

# Instalamos OhMyPosh
RUN curl -s https://ohmyposh.dev/install.sh | bash -sh
COPY .zshrc /root/.zshrc

# Configurar el directorio para las llaves SSH
RUN mkdir /keys

# Agregar nuestro archivo secreto
COPY .secret /root/.secret

# Añadir nuestro script de inicio
RUN mkdir /run/sshd
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Exponer el puerto 22 para el servicio SSH
EXPOSE 22

# Ejecutar nuestro script de inicio que configura y arranca el servidor SSH
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
