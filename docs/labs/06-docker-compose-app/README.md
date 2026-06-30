# Lab 06 – Docker Compose App

## What you're building

A three-service application: nginx as reverse proxy, a Python app backend, and Redis for persistent visit counting. All services communicate over a named Docker network.

**Concepts used:** `docker-compose.yml`, services, `depends_on`, `healthcheck`, named volumes, named networks, nginx reverse proxy.

```
Internet
    │
    ▼
[nginx:8080]  ←── reverse proxy
    │
    ▼
[app:5000]   ←── Python backend (counts visits)
    │
    ▼
[redis:6379] ←── persistent counter (volume: redisdata)
```

## Goal

Start all three services with one command, verify inter-service communication, and shut down cleanly.

## Prerequisites

- Docker Desktop running
- Module 13 completed
- `redis` Python package (installed in the compose app container by the lab steps)

## Step by Step

### Step 1: Go to the lab directory

```bash
cd docs/labs/06-docker-compose-app/compose
ls
# Expected output:
# app.py  docker-compose.yml  nginx.conf
```

### Step 2: Install the redis dependency into the app service

The app needs the `redis` Python package. Add a requirements.txt:

```bash
echo "redis==5.0.8" > requirements.txt
```

Update `docker-compose.yml` — change the `app` service command to install first:

```yaml
  app:
    image: python:3.12-slim
    working_dir: /app
    volumes:
      - ./app.py:/app/app.py:ro
      - ./requirements.txt:/app/requirements.txt:ro
    command: sh -c "pip install -q -r requirements.txt && python app.py"
```

### Step 3: Start all services

```bash
docker compose up -d
# Expected output:
# [+] Running 4/4
#  ✔ Network lab06-network       Created
#  ✔ Container compose-cache-1   Started
#  ✔ Container compose-app-1     Started
#  ✔ Container compose-web-1     Started
```

### Step 4: Check service status

```bash
docker compose ps
# Expected output:
# NAME               IMAGE           STATUS          PORTS
# compose-app-1      python:3.12-slim  Up            
# compose-cache-1    redis:7-alpine    Up (healthy)  
# compose-web-1      nginx:alpine      Up            0.0.0.0:8080->80/tcp
```

### Step 5: Test the app

```bash
curl http://localhost:8080
# Expected output:
# Hello from the app service!

curl http://localhost:8080/health
# Expected output:
# {"status": "ok"}

curl http://localhost:8080/count
# Expected output:
# {"visits": 1}

curl http://localhost:8080/count
# Expected output:
# {"visits": 2}
```

### Step 6: Watch logs

```bash
docker compose logs -f
# Press Ctrl+C to stop following
```

### Step 7: Test Redis persistence

```bash
# Stop and restart — visit count should persist
docker compose restart cache
curl http://localhost:8080/count
# Expected output: visits > 2 (counter preserved in volume)
```

## Validation

```bash
curl -s http://localhost:8080/health | grep -q '"ok"' && echo "App healthy"
docker compose ps --format "{{.Service}}: {{.Status}}" | grep -v "Exit"
```

## Cleanup

```bash
docker compose down -v
# -v also removes the redisdata volume
```

## Extension Task

Add a fourth service — a `adminer` (database admin) container on port 8081, connected to the same network. Adminer is a lightweight database admin UI (`image: adminer`).
