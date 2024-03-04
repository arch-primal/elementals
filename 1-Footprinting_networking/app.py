import os
import socket

# Usa una variable de entorno para la cadena secreta
KEY = os.getenv('KEY', 'DEFAULT_KEY')
SUCCESS = os.getenv('SUCCESS', b'Success').encode()

HOST = '0.0.0.0'
PORT = 80

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print(f"Escuchando en {HOST}:{PORT}...")
    while True:
        conn, addr = s.accept()
        with conn:
            print('Connected by', addr)
            data = conn.recv(1024)
            if data.decode() == KEY: # Para eliminar espacios en blanco y saltos de lía utilizar data.decode().strip()
                conn.sendall(SUCCESS)
                print("Mensaje de éxito enviado, cerrando conexión.")
                conn.close()
            else:
                print("Datos incorrectos recibidos, cerrando conexión.")
                conn.close()
