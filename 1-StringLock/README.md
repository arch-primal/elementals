# StringLock

## Descripción

Este proyecto desarrolla una aplicación en Python que expone un puerto dentro del host, el cual solo es accesible al proporcionar una cadena de caracteres correcta. Se plantea como un ejercicio práctico para evaluar conceptos de Footprinting (Recolección de Información Activa) y Networking. Para acceder a este laboratorio, será necesario llevar a cabo la enumeración de hosts dentro de una red y la enumeración de puertos, ofreciendo así una experiencia práctica en técnicas de exploración y seguridad informática.


## Instalación y Despliegue de StringLock

Para iniciar el despliegue de StringLock en tu entorno, asegúrate de tener Docker instalado en tu sistema. Si aún no lo tienes, visita [la página oficial de Docker](https://docs.docker.com/get-docker/) para obtener instrucciones detalladas sobre cómo instalarlo en tu plataforma específica.

Una vez que tengas Docker preparado, sigue los siguientes pasos para desplegar StringLock:

1. **Clona el Repositorio**

```bash
git clone https://github.com/arch-primal/elementals-labs.git
cd StringLock
```

2. **Construye la Imagen Docker**:

Abre una terminal en el directorio donde se encuentra el `Dockerfile` de StringLock y ejecuta el siguiente comando para construir la imagen Docker de la aplicación:

```bash
docker build -t stringlock-image .
```

Este comando construye una nueva imagen Docker, nombrándola `stringlock-image` basándose en las instrucciones proporcionadas en el `Dockerfile` en el directorio actual.

3. **Ejecuta el Contenedor**:

Una vez completada la construcción de la imagen, inicia un contenedor basado en esta imagen con el siguiente comando:

```bash
docker run -d --name stringlock-container -p PUERTO_LOCAL:80 -e KEY='Tu_cadena_secreta' -e SUCCESS='Tu cadena para conexiones exitosas' -e PROTOCOL='TPC' stringlock-image
```

Reemplaza `PUERTO_LOCAL` con el puerto en tu máquina anfitriona que deseas usar para acceder a StringLock y reemplaza `Tu_cadena_secreta` con la cadena que quieras que el usuario ingrese para acceder al host. La variable `PROTOCOL` admite tanto TCP como UDP para que se pueda encontrar el recurso con ambos protocolos.
No olvides que puedes configurar la cadena que se evaluará con la variable `KEY` y puedes personalizar el mensaje que devolverá en caso la conexión sea exitosa con la variable `SUCCESS`. Si estos valores no se modifican por defecto mostraá el mensaje "Success" cuando se haga una conexión exitosa, y la cadena que se estará esperando será "DEFAULT_KEY".

> **Nota:** Si deseas que la máquina sea visible solo por UDP, deberás agregar el protocolo al puerto (-p PUERTO_LOCAL:80/udp) y a la variable `PROTOCOL` deberás indicarle `PROTOCOL='UDP'`.

## Solución de máquina

1. **Discovery host**
Para la solución de la máquina deberemos escanear la red para encontrar el host, como por ejemplo:

```bash
nmap -sn 192.168.0.0/24
```

No olvides reemplazar la IP 192.168.0.0 por la IP dentro de la red que quieres escanear.

2. **Port scanning**

Con el listado de host activo deberemos buscar, en cada uno, los puertos que están abiertos. Nuestros puertos se encontrarán en estado _open_ y _open|Filtered_ para TCP y UDP, respectivamente. Es probable que encontremos tecnologías como _http-proxy_ para TCP y _http-alt_ para UDP.

```bash
nmap -Pn -p- 192.168.0.2
```

No olvides reemplazar la IP 192.168.0.2 con las IPs de los hosts que hayas encontrado en la red. Si configuraste la máquina para que corriera con UDP deberás especificarlo en tu búsqueda.

```bash
nmap -Pn -p- -sU 192.168.0.2
```

3. **Testing port**

Una vez hayamos obtenido los puertos que están abiertos, deberemos probar enviar la cadena para ver si el puerto nos responde.

```bash
echo -n "Tu cadena" | nc 192.168.0.2 8080
```
Si configuraste la máquina para que corriera con UDP, también deberás especificarlo al enviar la cadena.

```bash
echo -n "Tu cadena" | nc -u 192.168.0.2 8080
```

No olvides reemplazar "Tu cadena" con el hash que hayas configurado al levantar el contenedor, así como la IP 192.168.0.2 de tus hosts y cambiar el puerto 8080 por los puertos que hayas encontrado abiertos.
Al finalizar si envías la cadena correcta, en el host correcto, en el puerto correcto, recibirás el mensaje de éxito que hayas configurado al levantar el contenedor o el mensaje "Success" en caso de que no.
