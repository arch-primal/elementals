import http.server, socketserver, base64

PORT = 8080

class AuthHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """ HTTP request handler with authentication. """

    def do_HEAD(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_AUTHHEAD(self):
        self.send_response(401)
        self.send_header('WWW-Authenticate', 'Basic realm=\"Demo\"')
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        """ Present frontpage with user authentication. """
        if self.headers.get('Authorization') == 'Basic ' + str(base64.b64encode(b'data:asdf'), 'utf-8'):
            http.server.SimpleHTTPRequestHandler.do_GET(self)
        else:
            self.do_AUTHHEAD()
            self.wfile.write(bytes('Unauthorized', 'utf-8'))

handler = AuthHTTPRequestHandler
httpd = socketserver.TCPServer(("", PORT), handler)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    pass
httpd.server_close()
