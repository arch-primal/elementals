# ShellShift

docker run -d -p 20-21:20-21 -p 10000-10100:10000-10100 --name mi_vsftpd vsftpd
lftp ftp://user:passwd@IpServer

curl ftp://192.168.0.49:5958/
curl -o [nombre archivo local] ftp://usuario:contraseña@[servidor FTP]:5958/[ruta/archivo/remoto]
curl -T [ruta/archivo/local] ftp://usuario:contraseña@[servidor FTP]:5958/[ruta/remota]/ -u usuario:contraseña

docker run -d -p 2222:22 -p 4455:445 shellshift-image
