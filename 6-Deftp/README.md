# DeFTP

- [1. Descripción general](#1-descripción-general)
- [2. Instalación y despliegue](#2-instalación-y-despliegue)
- [2.1. Despliegue Manual](#21-despliegue-manual)
- [2.2. Despliegue automático](#22-despliegue-automático)
- [3. Descripción del laboratorio](#3-descripción-del-laboratorio)
- [4. Resolución del laboratorio](#4-resolución-del-laboratorio)
- [4.1. Cracking de credenciales](#41-cracking-de-credenciales)
- [4.2. Instalación del servicio FTP](#42-instalación-del-servicio-ftp)
- [4.3. Configuración del servicio FTP](#43-configuración-del-servicio-ftp)
- [4.4. Lanzamiento del servicio FTP](#44-lanzamiento-del-servicio-ftp)
- [4.5. Prueba del servicio FTP](#45-prueba-del-servicio-ftp)
- [4.6. Actualización de credenciales en el cliente](#46-actualización-de-credenciales-en-el-cliente)
- [4.7. Lectura de la flag](#47-lectura-de-la-flag)

## 1. Descripción general

Este laboratorio es una simulación de un enterno de cliente-servidor, en el cual se profundizará en la configuración de servicios FTP. Utiliza Docker para simular dos servidores diferentes, cada uno con configuraciones específicas destinadas a desafiar al usuario a utilizar una variedad de herramientas y técnicas de administración.

## 2. Instalación y despliegue

Antes de iniciar el laboratorio, asegúrate de tener Docker instalado en tu sistema. Si no tienes Docker, puedes instalarlo siguiendo las instrucciones en el sitio oficial de Docker para [Windows](https://docs.docker.com/docker-for-windows/install/), [Mac](https://docs.docker.com/docker-for-mac/install/) o [Linux](https://docs.docker.com/engine/install/).
Para el despliegue, tanto manual como automático, será necesario crear una red en Docker de tipo _bridge_:

```bash
docker network create deftp
```

### 2.1. Despliegue Manual

Para desplegar manualmente el laboratorio, deberás clonar este repositorio y ejecutar los comandos Docker para su lanzamiento:

```bash
git clone https://github.com/oppaisdf/elementals-labs.git
docker build -t kradbyte/deftp:server -f Dockerfile.server elementals-labs/6-Deftp
docker build -t kradbyte/deftp:client -f Dockerfile.client elementals-labs/6-Deftp
docker run -d --name deftp-server -p [ServerPort]:22 --network deftp kradbyte/deftp:server
docker run -d --name deftp-client --network deftp kradbyte/deftp:client
```

No olvides reemplazar `ServerPort` por el puerto en el que expondrás el servicio SSH.

### 2.2. Despliegue automático

Para desplegar el laboratorio automáticamente bastará con ejecutar los siguientes comandos:

```bash
docker run -d --name deftp-server -p [ServerPort]:22 --network deftp kradbyte/deftp:server
docker run -d --name deftp-client --network deftp kradbyte/deftp:client
```

No olvides reemplazar `ServerPort` por el puerto en el que expondrás el servicio SSH.

> **Nota**: No se recomienda cambiar el nombre de los contenedores, dado que hay configuraciones internas que funcionan con la resolución de los DNS de los contenedores, por lo que solo es posible cambiar el nombre de los contenedores si cambiamos las configuraciones también.

## 3. Descripción del laboratorio

**Description**
Perteneces al área de TI y te informan que Pato debe enviar respaldos de información importante al servidor, por lo que debes hacer las configuraciones pertinentes para que el servidor pueda recibir el documento por FTP. Por desgracia no te dieron las credenciales del servidor, por lo que tendrás que resolver cómo ingresar por tu cuenta, teniendo en cuenta que tu rol dentro del servidor es de administrador.

**Target**
Configura el servidor para recibir el archivo (flag de este laboratorio) por FTP

**Steps**
- Ingresa al servidor por SSH.
- Configura el servicio FTP.
- Espera los archivos del cliente por FTP y busca la flag entre los archivos recibidos.

**Grants**
- Para los comandos necesarios que se ejecutan como “sudo” no es necesaria la contraseña.
- En caso de solicitar contraseña para FTP podrás modificar la solicitud del lado del cliente sin modificar el contenedor con “docker exec”.

**Run**
Para leer la flag se deberán leer los archivos de forma óptima, recuerda que eres administrador.

**Tools**
Hydra, SSH, FTP, Curl, vsftpd.

**Note**
El laboratorio está pensado para solucionarse sin necesidad de modificar configuraciones directas con “docker exec -it”, favor de abstenerse de ingresar como root, a menos que se encuentre una solución diferente y que dicha ruta no esté contemplada como la solución original. Estas modificaciones se verificarán en la documentación de la solución del laboratorio.

## 4. Resolución del laboratorio

### 4.1. Cracking de credenciales

Primero deberemos crackear las credenciales de la SSH para acceder al servidor. La descripción nos proporciona información acerca de que nuestro rol es de administrador, por lo podremos ingresar como _admin_, por lo que ahora deberemos buscar la contraseña con herramientas como _hydra_:

```bash
hydra -L admin -p /ruta/a/tu/diccionario ssh://ServerIP:ServerPort
```

Recuerda cambiar `ServerIP` y `ServerPort` por la IP del servidor y el puerto, si se configuró uno diferente al puerto 22, por donde corre la SSH.

### 4.2. Instalación del servicio FTP

Primero deberemos revisar los comandos que podemos ejecutar como root, dado que si intentamos convertirnos en root nos pedirá la contraseña:

```bash
sudo -l
```

Al ejecutar el comando notaremos que no necesitamos ingresar la contraseña para ciertos comandos. Uno de ellos es de instalación de programas, por lo que podremos instalar FTP sin la contraseña de root.

```bash
sudo apt-get install -y vsftpd
```

### 4.3. Configuración del servicio FTP

Una vez hayamos instalado _vsftpd_ debermos modificar el archivo de configuración de FTP.

```bash
sudo nano /etc/vsftpd.conf
```

Para la configuración más sencilla debemos localizar las líneas que dicen "listen" y "listen_ipv6", pasar "listen" a YES y "listen_ipv6" a NO, y deberemos agregar las siguientes líneas al archivo:

```bash
anon_root=/home/admin
write_enable=YES
pasv_min_port=40000
pasv_max_port=40010
```

Podremos configurar otro rango diferente para los puertos pasivos, siempre y cuando no estén ocupados por otro servicio y sean consecutivos. La ruta que está en "anon_root" es la ruta a la que se conectarán y guardarán los archivos compartidos por FTP, por lo que podemos crear otro directorio si así lo queremos, este es solo un ejemplo, lo ideal es crear otro usuario específico para FTP y una ruta específica también.

### 4.4. Lanzamiento del servicio FTP

Una vez hayamos guardado nuestra configuración, podremos iniciar o reiniciar el servicio FTP:

```bash
sudo service vsftpd start
```

### 4.5. Prueba del servicio FTP

Para probar que nuestro servicio FTP se haya configurado correctamente y esté funcionando podremos instalar el cliente FTP o hacer un "curl":

```bash
curl -T <(echo "Test") ftp://admin:Password@localhost
curl ftp://admin:Password@localhost
```

Asegúrate de cambiar `Password` por la contraseña que hayas encontrado en pasos anteriores, por defecto las credenciales para SSH, FTP, etc., son las mismas que para el usuario, a menos que se configure una contraseña diferente para cada servicio.

### 4.6. Actualización de credenciales en el cliente

Cuando hayamos verificado que nuestro servicio FTP funciona correctamente, deberemos modificar la IP del lado del cliente para que pueda hacer la transferencia de los archivos. Esto únicamente si no configuramos FTP para que admitiera usuarios anónimos. Si verificamos las tareas cron notaremos que hay una solicitud HTTP al cliente, por lo que podemos deducir que hay un servidor HTTP en el cliente.

```bash
curl http://deftp-client
```

Cuando hayamos verficado las respuestas del cliente encontraremos un archivo con la IP del servidor (nombre del contenedor):

```bash
curl http://deftp-client/serverip.txt
```

Para actualizar este archivo podremos realizar un POST/PUT al servidor HTTP en el cliente, con el archivo correcto con las credenciales del servicio FTP:


```bash
echo "admin:Password@deftp-server" > server.txt
curl -T server.txt http://deftp-client/serverip.txt
```

No olvides reemplazar `Password` con la contraseña que hayas encontrado en pasos anteriores. Se recomienda colocar el nombre de los contenedores para que Docker resuelva los DNS internamente, pero se pueden colocar las IP directamente de los contenedores; en este ejemplo se utilizan los nombres de los contenedores porque Docker puede asignar las IP dinámicamente y podría cambiar entre este guía y el despliegue.

### 4.7. Lectura de la flag

Una vez hayamos cambiado las credenciales en el cliente bastará con esperar los archivos. Al recibir los 100 archivos deberemos buscar en cada uno la flag, para ello podremos hacer un script en bash o ejecutar un comando de un cliclo como el siguiente:

```bash
for file in {1..100}; do
    base64 -d "a$file"
done
```
