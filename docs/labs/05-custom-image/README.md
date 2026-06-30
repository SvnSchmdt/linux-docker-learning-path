# Lab 05 – Custom Image

## What you're building

You'll write a Dockerfile for the included Python web server, build the image, run it, and test it with `curl`. Then you'll tag the image for a registry.

**Concepts used:** Dockerfile, `docker build`, `docker run`, `docker tag`, layer caching, `.dockerignore`.

```
docs/labs/05-custom-image/
├── app/
│   └── app.py        ← Python web server (included)
└── Dockerfile        ← you write this
```

```
Build                     Run
────────────────────     ──────────────────────
app.py + Dockerfile  →   Image → Container
                              ↓
                         curl :8080      → "Hello from Docker!"
                         curl :8080/health → {"status": "ok"}
```

## Goal

Build a Docker image from a Python app, run it, and verify it responds to HTTP requests.

## Prerequisites

- Docker Desktop running
- Module 10 completed

## Step by Step

### Step 1: Go to the lab directory

```bash
cd docs/labs/05-custom-image
ls app/
# Expected output:
# app.py
```

### Step 2: Create .dockerignore

```bash
cat > .dockerignore << 'EOF'
__pycache__/
*.pyc
.env
.DS_Store
EOF
```

### Step 3: Write the Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM python:3.12-slim
WORKDIR /app
COPY app/app.py .
ENV PORT=8080
EXPOSE 8080
CMD ["python", "app.py"]
EOF
```

### Step 4: Build the image

```bash
docker build -t myapp:v1 .
# Expected output:
# [+] Building 8.2s (7/7) FINISHED
#  => [internal] load build definition from Dockerfile
#  => [1/3] FROM python:3.12-slim
#  => [2/3] WORKDIR /app
#  => [3/3] COPY app/app.py .
#  => exporting to image
```

### Step 5: Check image size

```bash
docker images myapp:v1
# Expected output:
# REPOSITORY   TAG   IMAGE ID       CREATED         SIZE
# myapp        v1    a1b2c3d4e5f6   5 seconds ago   151MB
```

### Step 6: Run the container

```bash
docker run -d --name myapp -p 8080:8080 myapp:v1
```

### Step 7: Test the app

```bash
curl http://localhost:8080
# Expected output:
# Hello from Docker!

curl http://localhost:8080/health
# Expected output:
# {"status": "ok"}
```

### Step 8: Check logs

```bash
docker logs myapp
# Expected output:
# Listening on port 8080
# 172.17.0.1 - GET / 200
# 172.17.0.1 - GET /health 200
```

### Step 9: Tag for registry

```bash
docker tag myapp:v1 myapp:latest
# If you have a Docker Hub account:
# docker tag myapp:v1 YOUR_USER/myapp:v1
```

## Validation

```bash
curl -s http://localhost:8080/health | grep -q "ok" && echo "Health check OK"
docker ps --filter "name=myapp" --format "{{.Status}}" | grep -q "Up" && echo "Container running"
```

## Cleanup

```bash
docker stop myapp && docker rm myapp
docker rmi myapp:v1 myapp:latest
```

## Extension Task

Rebuild with `python:3.12-alpine` as the base image and compare sizes:

```bash
# Edit Dockerfile: change python:3.12-slim → python:3.12-alpine
docker build -t myapp:v2-alpine .
docker images | grep myapp
```
