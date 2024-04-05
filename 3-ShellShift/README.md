
# ShellShift

- [1. Instalación y despliegue](#instalación-y-despliegue)
- [1.1. Despliegue de contenedor automático](#despliegue-de-contenedor-automático)
- [1.2. Despliegue de contenedor manual](#despliegue-de-contenedor-manual)
- [2. Descripción de ejercicio](#descripción-de-ejercicio)
- [3. Solución de ejercicio](#solución-de-ejercicio)

## 1. Instalación y despligue

Para desplegar el laboratorio es necesario tener [Docker](http://docs.docker.com/get-docker/) instalado. Una vez instalado podremos descargar o construir la imagen.

### 1.1. Despliegue de contenedor automático

Para desplegar el contenedor automáticamente, bastará con ejecuta rel siguiente comando:

```bash
docker exec -d --name shellshift-conotainer -p [Host-Port1]:21 -p [Host-Port2]:22 -p [Host-Port-range]:40000-40010 kradbyte/shellshift:latest
```

Asegúrate de reemplazar `Host-Port1`, `Host-Port2` y `Host-Port-range` con tus puertos para los servicios FTP, SSH y FTP Passive, respectivamente, en caso de querer utilizar puertos personalizados.

### 1.2. Despliegue de contenedor manual

Para desplegar el contenedor manualmente primero deberemos clonar el repositorio y construir la imagen:

```bash
git clone https://github.com/kradbyte/elementals-labs.git
docker build -t kradbyte/shellshift:latest elementals-labs/3-ShellShift
```

Una vez tengamos la imagen construida podremos desplegar el contenedor:

```bash
docker run -d --name shellshift-container -p [Host-port1]:21 -p [Host-port2]:22 -p[Host-port-range]:400000-40010 kradbyte/shellshift:latest
```

Asegúrate de reemplazar `Host-Port1`, `Host-Port2` y `Host-Port-range` con tus puertos para los servicios FTP, SSH y FTP Passive, respectivamente, en caso de querer utilizar puertos personalizados.

# 2. Descripción de ejercicio

*Contexto:* Te encuentras en una encrucijada en tu puesto de trabajo en el departamento de Atención al Cliente de una empresa reconocida. Hace una semana, desafortunadamente perdiste un archivo crucial que contenía tanto una llave de acceso como el enlace a una reunión empresarial importante programada para la próxima semana. La política interna de la empresa es implacable con los errores, y temes que admitir tu descuido pueda costarte el puesto. Afortunadamente, has descubierto que las credenciales perdidas están almacenadas en el servidor de la empresa. No tienes contactos en el departamento de TI, pero el destino te ha sonreído al encontrar un correo electrónico desechado que podría ser tu salvación:

> Good morning, Pato. I will be glad to assist you with your request. Please, provide your IP address by uploading it to the "ips" folder, naming the file "PatoIP.txt". Remember to connect as a "guest" user. Best regards.

*Target:* Recupera el archivo perdido siguiendo las pistas proporcionadas. Este viaje te llevará a interactuar con un servicio FTP, donde deberás compartir tu IP y puerto para obtener acceso a la consola del servidor. 

*Steps:*
1. Identificar servicio FTP
2. Acceder al servicio FTP
3. Compartir IP y puerto de escucha
4. Esperar conexión al servidor
4. Buscar archivo perdido: El archivo que necesitas recuperar tiene una extensión “.sh” y un tamaño de 15 KB.

*Grants:*
1. IP de Windows vs. WSL: Ten en cuenta que las direcciones IP pueden variar entre Windows y WSL. Asegúrate de proporcionar la IP correcta para evitar complicaciones.
2. Para facilitar tu trabajo y evitar tener que repetir pasos, considera establecer algún método para ganar un acceso más estable.
3. Todos los servicios corren entre los puertos 2100-2300.

*Tools:*
FTP, Curl, NetCat, Hydra, Nmap, SSH

# 3. Solución de ejercicio

## 3.1. Identificación de servicio FTP

Si se configuraron los puertos para que el servicio FTP corriera por un puerto distinto al 21, se debe utilizar alaguna herramienta de escaneo, como Nmap, para descubrir dicho servicio.

```bash
nmap -sn 192.168.0.0/24
```

## 3.2. Crackeo de credenciales FTP

Una vez hayamos ubicado el servicio FTP, el correo que se menciona en la descripción del ejercicio nos menciona que podemos subir un archivo al sevidor, pero primero deberemos descubrir la contraseña. Para eso podemos utilizar herramientas como *[Hydra](https://www.kali.org/tools/hydra/)* que nos ayudarán a descubrir las credenciales. Si prestamos atención al correo sabremos que el usuario del servicio es **guest**, por lo que solo deberemos descubrir la contraseña. Podemos utilizar algún diccionario de [SecList](https://github.com/danielmiessler/SecLists/blob/master/Passwords/500-worst-passwords.txt).

```bash
hydra -l guest -P /ruta/a/tu/diccionario.txt ftp://ServerIP:ServerPort
```

No olvides reemplazar `ServerIP` y `ServerPort` con la IP y el puerto del servidor por donde corre el servicio de FTP, así como la ruta de tu diccionario.

## 3.3. Suplantación de identidad

Una vez hayamos obtenido las credenciales del servicio FTP deberemos enviar nuestra IP y nuestro puerto de escucha, para que el servidor nos envíe una consola interactiva como si fuésemos Pato. Podemos utilizar FTP o curl para enviar el archivo:

```bash
curl -T <(echo "ClientIP:ClientPort") ftp://UserServer:PassServer@ServerIP:ServerPort/ips/PatoIP.txt
```

No olvides reemplazar `ClientIP` y `ClientPort` por la IP y el puerto de Host, así como `UserServer` y `PassServer` por la IP y el puerto del Servidor.

## 3.4. Reverse Shell

Cuando hayamos enviado nuestra IP al servidor deberemos ponernos en escucha para recibir la consola interactiva. Para ello podemos utilizar alguna herramienta como NetCat.

```bash
nc -lnvp 4444
```

## 3.5. Conexiones perdurables

Cuando el servidor nos entregue la consola interactiva podremos buscar la flag del laboratorio, pero la conexión que tenemos actualmente no será perdurable ya que cada dos minutos perderemos la conexión y deberemos repetir el proceso de enviar nuestra IP al servidor para conectarnos nuevamente, por lo que deberemos buscar una conexión persistente para evitar este inconveniente. Para ello utilizaremos SSH.

