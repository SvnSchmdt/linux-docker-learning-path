# Mission 14 – Build a Mini Webserver

## Scenario

You need to understand what a web server actually does before you put one in a Docker container. In this mission, you'll build one from scratch using Python's standard library — no frameworks, no dependencies.

Then you'll Dockerize it.

## Goal

Write a minimal HTTP server in Python, run it, test it, and containerize it. Understand every line.

## What you will practice

- Python's `http.server` module
- HTTP response structure (status, headers, body)
- Environment variable configuration
- Writing a `Dockerfile` for a simple Python app
- `docker build` and `docker run`

## Setup

```bash
mkdir -p ~/linux-missions/mission-14/app
echo "Mission 14 ready."
```

## Mission

**Part 1 — Write the server**

```bash
cat > ~/linux-missions/mission-14/app/server.py << 'EOF'
#!/usr/bin/env python3
"""Minimal HTTP server — reads PORT from environment."""
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.environ.get("PORT", 8080))
APP_VERSION = os.environ.get("APP_VERSION", "1.0.0")


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self._respond(200, {"status": "ok", "version": APP_VERSION})
        elif self.path == "/":
            self._respond(200, {"message": "Hello from Linux Mission 14!", "port": PORT})
        else:
            self._respond(404, {"error": "not found", "path": self.path})

    def _respond(self, code, data):
        body = json.dumps(data).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(f"[{self.log_date_time_string()}] {self.address_string()} {fmt % args}", flush=True)


if __name__ == "__main__":
    print(f"Starting server on port {PORT} (version {APP_VERSION})", flush=True)
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
EOF
```

**Part 2 — Run it locally**

```bash
# Start in background
PORT=9090 python3 ~/linux-missions/mission-14/app/server.py &
SERVER_PID=$!
sleep 1

# Test it
curl -s http://localhost:9090/
curl -s http://localhost:9090/health
curl -s http://localhost:9090/does-not-exist

# Stop it
kill $SERVER_PID
```

Questions:

1. What does `/health` return?
2. What HTTP status code does the 404 route return?
3. Where does the `version` field come from?

**Part 3 — Write the Dockerfile**

```bash
cat > ~/linux-missions/mission-14/Dockerfile << 'EOF'
FROM python:3.12-slim

WORKDIR /app

COPY app/server.py .

ENV PORT=8080
ENV APP_VERSION=1.0.0

EXPOSE 8080

USER nobody

CMD ["python3", "server.py"]
EOF
```

Questions before building:

4. Why `python:3.12-slim` and not `python:3.12`?
5. What does `EXPOSE 8080` actually do? (Hint: less than you think)
6. Why run as `nobody` instead of root?

**Part 4 — Build and run in Docker**

```bash
cd ~/linux-missions/mission-14/

docker build -t mission14-server:1.0.0 .

# Run it
docker run -d --name mission14 -p 9091:8080 -e APP_VERSION=1.0.0 mission14-server:1.0.0

sleep 1

# Test through Docker
curl -s http://localhost:9091/
curl -s http://localhost:9091/health

# Check logs
docker logs mission14
```

**Part 5 — Override configuration**

```bash
# Run with a different port and version (shows environment variable override)
docker run -d --name mission14-v2 \
  -p 9092:9000 \
  -e PORT=9000 \
  -e APP_VERSION=2.0.0 \
  mission14-server:1.0.0

sleep 1
curl -s http://localhost:9092/health
# Expected: {"status": "ok", "version": "2.0.0"}
```

**Part 6 — Inspect the image**

```bash
# Image size
docker image ls mission14-server

# Layers
docker history mission14-server:1.0.0

# Running container details
docker inspect mission14 | python3 -m json.tool | grep -A2 '"Ports"'
```

**Bonus:** What would you add to this server to make it production-ready? Think: logging format, graceful shutdown, connection limits, metrics endpoint.

## Hints

??? hint "Hint 1 – Why slim images"
    ```
    python:3.12      ≈ 1.0 GB  (includes build tools, Debian full)
    python:3.12-slim ≈ 130 MB  (Debian minus most extras)
    python:3.12-alpine ≈ 55 MB (musl libc, different binaries)

    Slim = good default. Alpine = smallest but can have compatibility issues.
    ```

??? hint "Hint 2 – What EXPOSE does (and doesn't do)"
    ```
    EXPOSE 8080 is documentation — it tells Docker which port the app uses.
    It does NOT publish the port. Publishing requires -p at runtime.
    Without -p, the container can still reach the port internally,
    but nothing outside the Docker network can.
    ```

??? hint "Hint 3 – Graceful shutdown"
    ```python
    import signal, sys

    def shutdown(sig, frame):
        print("Shutting down...", flush=True)
        sys.exit(0)

    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)
    ```

## Validation

```bash
# Local server works
PORT=9090 python3 ~/linux-missions/mission-14/app/server.py &
sleep 1
curl -s http://localhost:9090/health | grep '"status": "ok"' && echo "Server OK"
kill %% 2>/dev/null

# Docker image exists
docker image ls mission14-server:1.0.0 | grep mission14 && echo "Image OK"

# Container responds
docker ps | grep mission14 || (docker start mission14 2>/dev/null; sleep 1)
curl -s http://localhost:9091/ | grep "Hello" && echo "Docker OK"
```

## Cleanup

```bash
docker stop mission14 mission14-v2 2>/dev/null || true
docker rm mission14 mission14-v2 2>/dev/null || true
docker rmi mission14-server:1.0.0 2>/dev/null || true
pkill -f "server.py" 2>/dev/null || true
rm -rf ~/linux-missions/mission-14
```

## What you should have learned

- An HTTP server is just: accept connection → read request → write response
- `BASE_HANDLER.do_GET` maps HTTP methods to Python methods — the framework is optional
- `FROM python:3.12-slim` is the right base for most Python apps; Alpine for size-critical images
- `ENV` in a Dockerfile sets defaults; `-e` at runtime overrides them
- `USER nobody` drops root privileges — containers shouldn't run as root
- `EXPOSE` is documentation; `-p host:container` is what actually publishes a port

## Next mission

[Mission 15 – Linux Namespaces: First Look →](15-linux-namespaces-first-look.md)
