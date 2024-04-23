FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
	cron vsftpd

# Archivos de configuración
COPY vsftpd.conf /root/vsftpd.conf
COPY mvkey.sh /root/mvkey.sh
COPY executescripts.sh /root/executescripts.sh

# Escript principal
COPY entryb.sh /usr/local/bin/entryb.sh
RUN chmod 700 /usr/local/bin/entryb.sh
ENTRYPOINT ["/usr/local/bin/entryb.sh"]
