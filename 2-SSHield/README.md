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
docker run -d --name sshield-container -p PUERTO_LOCAL:22 -e KEY='YOUR_PASSWORD' sshield-image
```

Reemplaza `PUERTO_LOCAL` con el puerto en tu máquina anfitriona que deseas usar para acceder a SSHield, al igual que deberás reemplazar `YOUR_PASSWORD` con tu contraseña para acceder a la máquina.

3.2. **Conexiones por llave pública**

Para configurar conexiones por llave pública, deberemos ejecutar el siguiente comando:

```bash
docker run -d --name sshield-container -p PUERTO_LOCAL:22 -v "$(pwd)/keys:/keys" sshield-image
```

Reemplaza `PUERTO_LOCAL` con el puerto de tu máquina anfitriona. Toma en cuenta que al ejecutar este comando deberás estar en el mismo directorio donde se encuentra el `Dockerfile`, dado que se monta un volumen con el directorio `keys`. En este directorio encontrarás la llave pública y privada para realizar la conexión.

## Solución de máquina

1. **Discovery Hosts**

Primero deberemos escanear la red para descubrir los hosts activos.

```bash
nmap -sn 192.168.0.0/24
```

No ovlides reemplazar 192.168.0.0 con la IP que estás auditando.

2. **Port scanning**

Con el listado de hosts activos que encontramos, deberemos buscar en cada uno, por TCP, los puertos que están biertos.

```bash
nmap -Pn -p- 192.168.0.1
```

No ovlides reemplazar 192.168.0.1 con cada host descubierto en el paso uno.

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

> Nota: en la carpeta `keys` encontrarás las llaves para conexiones SSH por llave pública. Deberás proporcionar el archivo `key` sin la extensión `.pub`, de la carpeta `keys` donde se encuentra el Dockerfile de SSHield. En caso de tener más de un contenedor por conexiones por llave pública, todos los contenedores solicitarán la misma llave pública.

Una vez hecha la conexión deberás encontrar el archivo `secret` en la máquina, que contendrá una cadena en base 64.
