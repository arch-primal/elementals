# Nitcoded

- [1. Descripción](#1-descripción)
- [2. Instalación y despliegue](#2-instalación-y-despliegue)
- [2.1. Despliegue manual](#21-despliegue-manual)
- [2.2. Despliegue atomático](#22-despliegue-atomático)
- [3. Descripción del laboratorio](#3-descripción-del-laboratorio)
- [4. Resolución del laboratorio](#4-resolución-del-laboratorio)
- [4.1. Lanzamiento de servidor](#41-lanzamiento-de-servidor)
- [4.2. Instalación y configuración de nftables](#42-instalación-y-configuración-de-nftables)
- [4.3. Desencriptación de flag](#43-desencriptación-de-flag)

## 1. Descripción

Este laboratorio es una simulación de un entorno cliente-servidor, en el cual se profundizará en la configuración de servidores HTTP y automatización de tareas. Utiliza Docker para simular dos servidores, cada uno con configuraciones específicas destinadas a desafiar al usuario a utilizar una variedad de herramientas y técnicas de administración.

## 2. Instalación y despliegue

Antes de iniciar el laboratorio, asegúrate de tener Docker instalado en tu sistema. Si no tienes Docker, puedes instalar siguiendo las instrucciones en el sitio oficial de Docker para [Windows](https://docs.docker.com/docker-for-windows/install/), [Mac](https://docs.docker.com/docker-for-mac/install/) o [Linux](https://docs.docker.com/engine/install/).
Para el despliegue, tanto manual como automático, será neceasrio crear una red en Docker de tipo _bridge_:

```bash
docker network create keydos
```

## 2.1. Despliegue manual

Para desplegar manualmente el laboratorio, deberás clonar este repositorio y ejecutar los siguientes comandos Docker para su lanzamiento:

```bash
git clone https://github.com/oppaisdf/elementals-labs.git
docker build -f kradbyte/keydos:attacker -f Dockerfile.attacker elementals-labs/8-KeyDOS
docker build -f kradbyte/keydos:client -f Dockerfile.client elementals-labs/8-KeyDOS
docker run -d --name keydos-attacker --network keydos kradbyte/keydos:attacker
docker run -d --name nitcoded-client --network keydos kradbyte/keydos:client
```

## 2.2. Despliegue automático

Para desplegar el laboratorio atomáticamente bastará con ejecutar los siguientes comandos:

```bash
docker run -d --name keydos-attacker --network keydos kradbyte/keydos:attacker
docker run -d --name keydos-client --network keydos kradbyte/keydos:client
```

## 3. Descripción del laboratorio

**Description**
Eres administrador de un servidor y deberás mitigar el ataque DOS para que los clientes puedan acceder al sitio sin problemas.

**Target**
Despliega el servidor y descifra la flag.

**Steps**
- Levantar y configura un servidor nginx.
- Mitiga el ataque DOS.
- Obtén la flag cifrada del cliente.
- Descifra la flag.

**Grants**
- Alpine es de las versiones más ligeras de Nginx (sugerencia).
- Libre de usar firewalld, iptables o nftables.
- Al alcanzar las 75 solicitudes exitosas del cliente, se mostrará la flag cifrada. Para seguir el log de las solicitudes podrás correr este comando:

```bash
docker exec keydos-client tail -f /root/sender.logs
```

- La llave y tipo de cifrado para la flag las envía el cliente como solicitud http, cada minuto divisible entre 5.

**Run**
- Para conectar los contenedores exitosamente deberás crear una red de tipo bridge. Una vez creada la red, podrás conectar los contenedores ejecutando “docker network connect NombreDeTuRed NombreDelContenedor” o agregando “--network NombreDeTuRed” en el “docker run…” (por cada contenedor).
- El nombre del contenedor que actuará como servidor deberá ser “server”, dado que las configuraciones de los contenedores resolverán este DNS y el cambio de nombre, a pesar de estar dentro de la misma red, afectará al funcionamiento general del laboratorio.

## 4. Resolución del laboratorio

### 4.1. Lanzamiento de servidor

Para lanzar el servidor podremos escoger cualquier versión de Nginx, para este ejemplo utilizaremos Alpine por ser de las versiones más ligeras. Dado que estaremos configurando un firewall necesitaremos permisos elevados.

```bash
docker run -d --name server --network keydos --privileged nginx:alpine
```
 Al levantar el contenedor prodremos ver mensajes de conexiones exitosas del lado del cliente en los logs:

```bash
docker exec keydos-client tail -f /root/sender.logs
```

Si prestamos atención es posible que los mensajes de éxito no superen las 30 conexiones exitosas, dado que hay un ataque DOS que tumba el servidor periódicamente, por lo que deberemos mitigar el ataque para que los clientes pueden acceder sin problemas.

### 4.2. Instalación y configuración de nftables

Para ingresar al contenedor deberemos ejecutar:

```bash
docker exec -it server sh
```

Una vez dentro deberemos instalar iptables, nftables o firewalld. En este ejemplo instalaremos nftables:

```bash
apk add nftables
```

La sintáxis de las reglas nftables podrían variar, pero el objetivo seguirá siendo mitigar un ataque DOS y sabremos que hemos tenido éxito cuando el cliente alcance las 75 conexiones consecutivas exitosas. Para este ejemplo hemos agregado un archivo [rules.sh](rules.sh), en el repositorio de este laboratorio, como script que configura las reglas para que podamos orientarnos en su configuración.

### 4.3. Desencriptación de flag

Cuando hayamos obtenido la flag encriptada en los logs del cliente deberemos buscar el método y la llave entre las peticiones que hace el cliente al servidor. Para analizar el tráfico podremos utilizar alguna herramienta como tcpdump:

```bash
tcpdump -i eth0 -w trafic.pcap
```

Una vez hayamos capturado el tráfico podremos analizarlo con Wireshark. Para pasarlo a nuestra máquina anfitriona podremos montar un servidor http sencillo con python o utilizar "scp". Toma en cuenta que si necesitas un puerto del servidor a tu máquina anfitriona tendrás que volver a lanzar el servidor:

```bash
docker rm -f server
docker run -d --name server --network keydos --privileged -p [HostPort]:[ServerPort] nginx:alpine
```

> **Nota**: Recuerda que si vuelves a lanzar el contenedor, perderás toda información y configuraciones que hayas hecho.

Cuando hayas obtenido la llave y el método de desencriptación podrás utilizar alguna herramienta online para obtener la flag y el laboratorio habrá sido resuelto.
