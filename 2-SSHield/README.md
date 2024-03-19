# SSHield

## Descripción
Este proyecto expone un puerto dentro del host, el cual solo es accesible por conexiones SSH.

## Instalación y despliegue de SSHield

Para iniciar el despliegue de StringLock en tu entorno, asegúrate de tener Docker instalado en tu sistema. Si aún no lo tienes, visita [la página oficial de Docker](https://docs.docker.com/get-docker/) para obtener instrucciones detalladas sobre cómo instalarlo en tu plataforma específica.
Una vez tengas Docker instalado, sigue los siguientes pasos para desplegar el proyecto:

1. **Clona el repositorio**

```bash
git clone https://github.com/kradbyte/elementals-labs.git
cd elementals-labs/2-SSHield
```

2. **Construye la Imagen Docker**

Abre una terminal en el directorio donde se encuentra el `Dockerfile` de SSHield y ejecuta el siguiente comando para construir la imagen Docker de la aplicación:

```bash
docker build -t sshield-image .
```

3. **Ejecuta el contenedor**

Una vez completada la construcción de la imagen, podrás lanzar el contenedor para exponer un puerto y establecer conexiones por SSH.
Toma en cuenta que puedes establecer la conexión por SSH tanto con una llave pública, como proporcionando una contraseña.

3.1. **Conexión por contraseña**

Para configurar conexiones por contraseña, deberemos ejecutar el siguiente comando:

```bash
docker run -d --name sshield-container -p PUERTO_LOCAL:22 -e KEY='YOUR_PASSWORD' -e USR='YourUserName' sshield-image
```

Reemplaza `PUERTO_LOCAL` con el puerto en tu máquina anfitriona que deseas usar para acceder a SSHield, al igual que deberás reemplazar `YOUR_PASSWORD` con tu contraseña para el usuario y `YourUserName` con el nombre de tu usuario al que te conectarás.
Toma en cuenta que si no configuras la variable de entorno `USR` se configurará la conexión para el usuario _root_.

3.2. **Conexiones por llave pública**

Para configurar conexiones por llave pública, deberemos ejecutar el siguiente comando:

```bash
docker run -d --name sshield-container -p PUERTO_LOCAL:22 -v "$(pwd)/keys:/keys" -e USR='YourUserName' sshield-image
```

Reemplaza `PUERTO_LOCAL` con el puerto de tu máquina anfitriona. Toma en cuenta que al ejecutar este comando deberás estar en el mismo directorio donde se encuentra el _Dockerfile_, dado que se monta un volumen con el directorio _keys_. En este directorio encontrarás la llave pública y privada para realizar la conexión.
Nota que al igual que las conexiones por contraseña, si no defines la variable `USR` la conexión se configurará para el usuario _root_.

## Solución de máquina

1. **Discovery Hosts**

Primero deberemos escanear la red para descubrir los hosts activos.

```bash
nmap -sn 192.168.0.0/24
```

No ovlides reemplazar _192.168.0.0_ con la IP que estás auditando.

2. **Port scanning**

Con el listado de hosts activos que encontramos, deberemos buscar en cada uno, por TCP, los puertos que están biertos.

```bash
nmap -Pn -p- 192.168.0.1
```

No ovlides reemplazar _192.168.0.1_ con cada host descubierto en el paso uno.

3. **Estableciendo la conexión**

Cuando hayamos descubierto los puertos que contengan algún servicio SSH, deberemos intentar conectarnos a dicho puerto. Si configuramos SSHield con contraseña deberemos ejecutar:

```bash
ssh -p PUERTO_LOCAL root@192.168.0.1
```

Una vez hecha la conexión nos solicitará la contraseña.
Si configuramos la máquina para conexiones con llave pública, deberemos ejecutar:

```bash
ssh -p PUERTO_LOCAL -i myPublicKey root@192.168.0.1
```

No olvides reemplazar `PUERTO_LOCAL` por el puerto que estés probando, así como la IP `192.168.0.1` por el host que estés verificando y `myPublicKey` por el archivo que contenga la llave pública.

> Nota: en la carpeta _keys_ encontrarás las llaves para conexiones SSH por llave pública. Deberás proporcionar el archivo `key` sin la extensión *.pub*, de la carpeta _keys_ donde se encuentra el Dockerfile de SSHield. En caso de tener más de un contenedor por conexiones por llave pública, todos los contenedores solicitarán la misma llave pública.

4. **Leyendo el archivo secreto**

Una vez dentro de la máquina deberemos encontrar el archivo *secret*, podremos utilizar un comando como el siguiente:

```bash
find / -name \*secret\* 2>/dev/null
```

Cuando hayamos ubicado la carpeta al intentar leer el archivo, es probable que no tengamos permiso. Pero dentro del directorio encontraremos el archivo *task.sh* que se ejecuta cada minuto.
Al examinar el archivo *task.sh* notaremos que ejecuta todos los scripts en la carpeta `/home/.user/scripts` como el usuario `.user`, que sí está autorizado para leer el archivo secreto, por lo que deberemos dirigirnos a la carpeta _scripts_:

```bash
cd /home/.user/scripts
```

Una vez dentro deberemos crear nuestro propio script para leer el archivo, como por ejemplo:

```bash
#!/bin/bash
cat /home/.user/.secret > /home/.user/secret
chmod 666 /home/.user/secret
```

Cuando se haya ejecutado nuestro script podremos ver el contenido del archivo *secret*. No olvides que no deberemos dejar rastro de que vimos el archivo _secret_, por lo que tendremos que hacer otro script para eliminar el archivo temporal con el que leímos el archivo _.secret_.
