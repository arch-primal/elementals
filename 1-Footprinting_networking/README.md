# StringLock
## Descripción
Claro que sí, papu. Incluir una descripción al inicio de tu documentación es una práctica excelente y sumamente recomendable. Proporciona un contexto inmediato a los usuarios sobre el propósito y el alcance del proyecto, permitiéndoles entender rápidamente si el repositorio satisface sus necesidades o intereses. Además, al presentar esta descripción tanto en español como en inglés, aseguras que tu proyecto sea accesible para una audiencia global más amplia.

Aquí te dejo una propuesta para la descripción en ambos idiomas, siguiendo la estructura bilingüe que hemos establecido:

---

## Descripción / Description

### Español

Este proyecto desarrolla una aplicación en Python que expone un puerto dentro del host, el cual solo es accesible al proporcionar una cadena de caracteres correcta. Se plantea como un ejercicio práctico para evaluar conceptos de Footprinting (Recolección de Información Activa) y Networking. Para acceder a este laboratorio, será necesario llevar a cabo la enumeración de hosts dentro de una red y la enumeración de puertos, ofreciendo así una experiencia práctica en técnicas de exploración y seguridad informática.

### English

This project builds a Python application that exposes a port within the host, which can only be accessed by providing the correct string. It is designed as a practical exercise to evaluate concepts of Footprinting (Active Information Gathering) and Networking. To access this lab, it will be necessary to perform host enumeration within a network and port enumeration, thereby offering a hands-on experience in scanning techniques and cybersecurity.

## Español
### Instalación y Despliegue de StringLock
Para iniciar el despliegue de StringLock en tu entorno, asegúrate de tener Docker instalado en tu sistema. Si aún no lo tienes, visita [la página oficial de Docker](https://docs.docker.com/get-docker/) para obtener instrucciones detalladas sobre cómo instalarlo en tu plataforma específica.

Una vez que tengas Docker preparado, sigue los siguientes pasos para desplegar StringLock:

1. **Clona el Repositorio** (opcional, si el código está en un repositorio):

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
docker run -d --name stringlock-container -p PUERTO_LOCAL:65432 stringlock-image
```

Reemplaza `PUERTO_LOCAL` con el puerto en tu máquina anfitriona que deseas usar para acceder a StringLock.

## English
### Installation and Deployment of StringLock

To begin deploying StringLock in your environment, ensure you have Docker installed on your system. If not, visit the [official Docker website](https://docs.docker.com/get-docker/) for detailed instructions on how to install it on your specific platform.

Once Docker is set up, follow these steps to deploy StringLock:

1. **Clone the Repository**

```bash
git clone https://github.com/arch-primal/elementals-labs.git
cd StringLock
```

2. **Build the Docker Image**:

Open a terminal in the directory where StringLock's `Dockerfile` is located and run the following command to build the Docker image of the application:

```bash
docker build -t stringlock-image .
```

This command builds a new Docker image named `stringlock-image` based on the instructions provided in the `Dockerfile` in the current directory.

3. **Run the Container**:

After the image has been built, start a container based on this image with the following command:

```bash
docker run -d --name stringlock-container -p LOCAL_PORT:65432 stringlock-image
```

Replace `LOCAL_PORT` with the port on your host machine you wish to use to access StringLock.
