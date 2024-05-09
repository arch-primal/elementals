# Elementals Labs

Un portal hacia el entendimiento y dominio de los conceptos fundamentales del hacking. Con laboratorios, meticulosamente diseñados, ofrecen un campo de juego interactivo para desafiar y desarrollar tus habilidades en un entorno seguro y controlado.

## 1. ¿Por qué Elementals Labs?

**Porque la práctica hace al maestro.**
Cada laboratorio ha sido cuidadosamente diseñado con el objetivo de ofrecer una experiencia de aprendizaje profunda y significativa que no solo te enseñe conceptos teóricos, sino que también te permita aplicarlos en escenarios prácticos. Estás a punto de embarcarte en una serie de aventuras que desafiarán tu ingenio, mejorarán tu comprensión y agudizarán tus habilidades de hacking ético.

## 2. Laboratorios

### 2.1. Footprinting & Networking

**Objetivos de Aprendizaje**:
- Comprender y aplicar técnicas de footprinting para recopilar información sobre sistemas objetivo.
- Practicar subneting y escaneo de puertos para identificar servicios vulnerables.

**Descripción**:
El laboratorio [StringLock](/1-StringLock) te desafía a descubrir un puerto oculto en un host. Utilizando tus habilidades de escaneo de red, deberás encontrar el puerto correcto que está esperando recibir una cadena. Si la cadena es correcta, el sistema responderá con un mensaje clave; de lo contrario, permanecerá en silencio. Este laboratorio puede ser configurado para trabajar tanto en TCP como en UDP, ofreciendo así una experiencia de aprendizaje versátil que te permitirá familiarizarte con ambos protocolos de red.

### 2.2. System Security & Hardening

**Objetivos de Aprendizaje**:
- Establecer y configurar conexiones SSH seguras.
- Navegar y explorar servidores para identificar y recopilar datos sensibles.

**Descripción**:
Con el laboratorio [SSHield](/2-SSHield), explorarás los fundamentos de SSH y el funcionamiento de los servidores bajo esta capa de seguridad. Se espera que establezcas una conexión SSH segura a un host designado y, una vez dentro, te sumergirás en un entorno desafiante donde deberás encontrar una "flag" oculta. Este laboratorio no solo pondrá a prueba tus habilidades de conexión segura sino que también te enseñará técnicas de exploración y recolección de información dentro de sistemas comprometidos.

### 2.3. Gaining persistence FT. Reverse Shell

**Objetivos de Aprendizaje**:
- Configurar conexiones SSH y FTP.
- Familiarizarse con la _reverse shell_ y la persistencia que se puede configurar al ganar acceso a un servidor.

**Descripción**:
El laboratorio [ShellShift](/3-ShellShift) está diseñado para repasar transferencia de archivos por FTP y generar llaves públicas y privadas para conexiones SSH.

### 2.4. Sniffing packages ft. Privileges escalation

**Objetivos de aprendizaje**:
- Interceptar y analizar paquetes del tráfico en red interna.
- Familiarizarse con la escala de privilegios.

**Descripción**
El laboratorio [SSharknet](/4-SSHarknet) está enfocado en practicar la captura de tráfico interno y esacala de privilegios.

### 2.5. Lateral Movement ft. Pivoting

**Objetivos de aprendizaje**:
- Comprender los escenarios de uso de la Reverse Shell.
- Analizar el potencial de poder ejecutar scripts en host.
- Familiarizarse con los concpetos de pivoting y movimiento lateral en hacking.

**Descripción**
El laboratorio [FTPivot](/5-FTPivot) está enfocado en la práctica de obtener una reverse shell, lectura e interpretación de logs.

### 2.6. Server management

**Objetivos de aprendizaje:**
- Familiarizarse con administración de servidores Linux.
- Comprender permisos de roles de usuarios.

**Descripción**
El laboratorio [DeFTP](/6-Deftp) está enfocado en la práctica de administración de servidores Linux, repasando los permisos de usuarios y configuración del servicio FTP.

### 2.7. Administration tasks ft. command's SSH

**Objetivos de aprendizaje:**
- Configurar tareas automáticas.
- Configuración básica de servicio HTTP.

**Descripción**
El laboratorio [Nitcoded](/7-Nitcoded) está enfocado en la práctica de implementar el servicio HTTP con capacidades POST/PUT y programar tareas automatizadas.

## 3. Comenzando

Para empezar con 'Elementals', asegúrate de tener Docker instalado en tu sistema. Cada laboratorio viene con instrucciones detalladas sobre cómo desplegarlo y configurarlo usando Docker, lo que te permitirá enfocarte en el aprendizaje y la práctica sin preocuparte por la configuración del entorno.

## 4. Contribuir

¿Interesado en contribuir? ¡Tus contribuciones son bienvenidas! Ya sea añadiendo nuevos laboratorios, mejorando la documentación existente o compartiendo soluciones y técnicas.
