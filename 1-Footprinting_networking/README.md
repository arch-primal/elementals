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
docker run -d --name stringlock-container -p PUERTO_LOCAL:65432 -e KEY='Tu_cadena_secreta' stringlock-image
```

Reemplaza `PUERTO_LOCAL` con el puerto en tu máquina anfitriona que deseas usar para acceder a StringLock y reemplaza `Tu_cadena_secreta` con la cadena que quieras que el usuario ingrese para acceder al host.
