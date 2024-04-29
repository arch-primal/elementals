import http.server
import os
from urllib.parse import unquote

class HTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
  def do_PUT(self):
    # Obtiene la longitud del contenido
    length = int(self.headers['Content-Length'])
    # Lee el contenido (datos del archivo)
    content = self.rfile.read(length)

    # Obtiene la ruta del archivo a guardar
    path = self.translate_path(self.path)
    dirname = os.path.dirname(path)
    if not os.path.exists(dirname):
      os.makedirs(dirname)

    # Escribe los datos en un archivo
    with open(path, 'wb') as f:
      f.write(content)

    # Envía una respuesta de éxito
    self.send_response(201)
    self.end_headers()
    self.wfile.write(b'Received file: ' + bytes(unquote(self.path), 'utf-8'))

## Configura y ejecuta el servidor
os.chdir('/home/pato')
server_address = ('', 80)
httpd = http.server.HTTPServer(server_address, HTTPRequestHandler)
httpd.serve_forever()
