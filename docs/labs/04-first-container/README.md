# Lab 04 – First Container

## What you're building

You'll pull an nginx image, run it with port mapping, inspect the logs, execute commands inside the container, and cleanly remove it. This is the fundamental Docker workflow you'll use constantly.

**Concepts used:** `docker pull`, `docker run`, `docker ps`, `docker logs`, `docker exec`, `docker stop`, `docker rm`.

```
Your Machine
┌─────────────────────────────────────┐
│  localhost:8080                     │
│      │                              │
│  ┌───▼───────────────────────────┐  │
│  │  Container: web               │  │
│  │  Image: nginx:alpine          │  │
│  │  Port: 80 (inside)            │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
        curl http://localhost:8080
```

## Goal

Run nginx in a Docker container and verify it serves HTTP traffic.

## Prerequisites

- Docker Desktop installed and running
- Module 10 completed (concepts)

## Step by Step

### Step 1: Pull the nginx image

```bash
docker pull nginx:alpine
# Expected output:
# alpine: Pulling from library/nginx
# ...
# Status: Downloaded newer image for nginx:alpine
# docker.io/library/nginx:alpine
```

### Step 2: Run the container

```bash
docker run -d --name web -p 8080:80 nginx:alpine
# Expected output:
# 3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b (container ID)
```

### Step 3: Verify it's running

```bash
docker ps
# Expected output:
# CONTAINER ID   IMAGE          COMMAND                  PORTS                  NAMES
# 3a4b5c6d7e8f   nginx:alpine   "/docker-entrypoint.…"   0.0.0.0:8080->80/tcp   web
```

### Step 4: Test the web server

```bash
curl http://localhost:8080
# Expected output (truncated):
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# ...
```

### Step 5: Read the access logs

```bash
docker logs web
# Expected output (after the curl above):
# /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
# /docker-entrypoint.sh: Configuration complete; ready for start up
# 172.17.0.1 - - [30/Jun/2026:10:00:01 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/8.4.0" "-"
```

### Step 6: Execute a command inside the container

```bash
docker exec web ls /etc/nginx/conf.d/
# Expected output:
# default.conf

docker exec -it web sh
# You're now inside the container:
# / # whoami
# root
# / # cat /etc/nginx/conf.d/default.conf
# / # exit
```

### Step 7: Inspect the container

```bash
docker inspect web | grep -A 5 '"IPAddress"'
# Expected output (truncated):
# "IPAddress": "172.17.0.2",
```

### Step 8: Stop and remove

```bash
docker stop web
# Expected output: web

docker rm web
# Expected output: web

docker ps -a | grep web
# Expected output: (empty — container is gone)
```

## Validation

```bash
# After cleanup: no 'web' container should exist
docker ps -a --filter "name=web" --format "{{.Names}}"
# Expected output: (empty)

# The image should still be locally cached
docker images nginx:alpine
# Expected output:
# REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
# nginx        alpine    ...            ...           ...
```

## Cleanup

```bash
# Remove the image if you want a clean slate
docker rmi nginx:alpine
```

## Extension Task

Start two nginx containers simultaneously on different ports:

```bash
docker run -d --name web1 -p 8080:80 nginx:alpine
docker run -d --name web2 -p 8081:80 nginx:alpine
curl http://localhost:8080
curl http://localhost:8081
docker stop web1 web2 && docker rm web1 web2
```
