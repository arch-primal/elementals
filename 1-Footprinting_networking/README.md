# StringLock

## Descripción / Description

Este proyecto desarrolla una aplicación en Python que expone un puerto dentro del host, el cual solo es accesible al proporcionar una cadena de caracteres correcta. Se plantea como un ejercicio práctico para evaluar conceptos de Footprinting (Recolección de Información Activa) y Networking. Para acceder a este laboratorio, será necesario llevar a cabo la enumeración de hosts dentro de una red y la enumeración de puertos, ofreciendo así una experiencia práctica en técnicas de exploración y seguridad informática.

---

This project builds a Python application that exposes a port within the host, which can only be accessed by providing the correct string. It is designed as a practical exercise to evaluate concepts of Footprinting (Active Information Gathering) and Networking. To access this lab, it will be necessary to perform host enumeration within a network and port enumeration, thereby offering a hands-on experience in scanning techniques and cybersecurity.


## Instalación y Despliegue de StringLock / Installation and Deployment of StringLock

Para iniciar el despliegue de StringLock en tu entorno, asegúrate de tener Docker instalado en tu sistema. Si aún no lo tienes, visita [la página oficial de Docker](https://docs.docker.com/get-docker/) para obtener instrucciones detalladas sobre cómo instalarlo en tu plataforma específica.

Una vez que tengas Docker preparado, sigue los siguientes pasos para desplegar StringLock:

---

To begin deploying StringLock in your environment, ensure you have Docker installed on your system. If not, visit the [official Docker website](https://docs.docker.com/get-docker/) for detailed instructions on how to install it on your specific platform.

Once Docker is set up, follow these steps to deploy StringLock:


1. **Clona el Repositorio / Clone the Repository**

```bash
git clone https://github.com/arch-primal/elementals-labs.git
cd StringLock
```

2. **Construye la Imagen Docker / Build the Docker Image**:

Abre una terminal en el directorio donde se encuentra el `Dockerfile` de StringLock y ejecuta el siguiente comando para construir la imagen Docker de la aplicación:

---

Open a terminal in the directory where StringLock's `Dockerfile` is located and run the following command to build the Docker image of the application:

```bash
docker build -t stringlock-image .
```

Este comando construye una nueva imagen Docker, nombrándola `stringlock-image` basándose en las instrucciones proporcionadas en el `Dockerfile` en el directorio actual.

---

This command builds a new Docker image named `stringlock-image` based on the instructions provided in the `Dockerfile` in the current directory.


3. **Ejecuta el Contenedor / Run the Container**:

Una vez completada la construcción de la imagen, inicia un contenedor basado en esta imagen con el siguiente comando:

---

After the image has been built, start a container based on this image with the following command:

```bash
docker run -d --name stringlock-container -p PUERTO_LOCAL:65432 stringlock-image
```

Reemplaza `PUERTO_LOCAL` con el puerto en tu máquina anfitriona que deseas usar para acceder a StringLock.

---

Replace `LOCAL_PORT` with the port on your host machine you wish to use to access StringLock.
