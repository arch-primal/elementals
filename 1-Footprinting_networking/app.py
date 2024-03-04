import os
import socket

# Usa una variable de entorno para la cadena secreta
KEY = os.getenv('KEY', 'DEFAULT_KEY')

HOST = '0.0.0.0'
PORT = 65432

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()
    with conn:
        print('Connected by', addr)
        while True:
            data = conn.recv(1024)
            if not data:
                break
            elif data.decode() == KEY:
                conn.sendall(b'Success')
            else:
                conn.close()
