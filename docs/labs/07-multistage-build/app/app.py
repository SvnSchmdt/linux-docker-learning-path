from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os

PORT = int(os.environ.get("PORT", 8080))


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = json.dumps({"status": "ok"}).encode()
            content_type = "application/json"
        else:
            body = b"Hello from a production-ready container!\n"
            content_type = "text/plain"
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(f"{self.address_string()} - {fmt % args}")


if __name__ == "__main__":
    print(f"Listening on port {PORT} (user: {os.getenv('USER', 'appuser')})")
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
