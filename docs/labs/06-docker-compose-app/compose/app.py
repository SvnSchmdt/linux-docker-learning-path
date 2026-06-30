from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import redis

PORT = int(os.environ.get("PORT", 5000))
REDIS_HOST = os.environ.get("REDIS_HOST", "localhost")


def get_redis():
    try:
        r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)
        r.ping()
        return r
    except Exception:
        return None


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        r = get_redis()
        if self.path == "/health":
            status = "ok" if r else "degraded"
            body = json.dumps({"status": status}).encode()
        elif self.path == "/count":
            count = r.incr("visits") if r else "redis unavailable"
            body = json.dumps({"visits": count}).encode()
        else:
            body = b"Hello from the app service!\n"

        self.send_response(200)
        self.send_header("Content-Type", "application/json" if self.path != "/" else "text/plain")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(f"{self.address_string()} - {fmt % args}")


if __name__ == "__main__":
    print(f"App listening on port {PORT}, redis at {REDIS_HOST}")
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
