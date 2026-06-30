# Lab 07 – Multi-Stage Build

## What you're building

You'll take the app from Lab 05 and build a production-hardened version: multi-stage build, Alpine base image, non-root user, and a healthcheck. Then you'll compare image sizes.

**Concepts used:** Multi-stage Dockerfile, `python:3.12-alpine`, non-root user, `HEALTHCHECK`, `--from=builder`, `docker scout`.

```
Stage 1: builder           Stage 2: runtime
──────────────────         ──────────────────────
python:3.12-slim     →     python:3.12-alpine
  install deps              copy only what's needed
  (with pip + gcc)          non-root user: appuser
                            HEALTHCHECK
                            smaller + more secure
```

## Goal

Build a multi-stage Docker image that's significantly smaller and more secure than the single-stage version.

## Prerequisites

- Lab 05 completed (understand single-stage builds)
- Module 15 completed

## Step by Step

### Step 1: Go to the lab directory

```bash
cd docs/labs/07-multistage-build
ls app/
# Expected output:
# app.py
```

### Step 2: Write the multi-stage Dockerfile

```bash
cat > Dockerfile << 'EOF'
# Stage 1: Builder (installs dependencies)
FROM python:3.12-slim AS builder
WORKDIR /build
COPY app/requirements.txt* ./
RUN pip install --no-cache-dir --target /build/packages -r requirements.txt 2>/dev/null || true

# Stage 2: Runtime (minimal, secure)
FROM python:3.12-alpine AS runtime
WORKDIR /app

# Create non-root user
RUN adduser --disabled-password --no-create-home appuser

# Copy app (no build tools, no pip cache)
COPY --chown=appuser:appuser app/app.py .
# Copy installed packages from builder stage (if any)
COPY --from=builder --chown=appuser:appuser /build/packages /usr/local/lib/python3.12/site-packages/

# Healthcheck using wget (available in alpine)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

USER appuser
ENV PORT=8080
EXPOSE 8080
CMD ["python", "app.py"]
EOF
```

### Step 3: Build the production image

```bash
docker build -t myapp:v2-prod .
# Expected output:
# [+] Building 18.4s (10/10) FINISHED
#  => [builder 1/3] FROM python:3.12-slim
#  => [runtime 1/4] FROM python:3.12-alpine
#  => [builder 2/3] WORKDIR /build
#  => [runtime 2/4] RUN adduser ...
#  => [runtime 3/4] COPY --chown=appuser:appuser app/app.py .
```

### Step 4: Compare image sizes

```bash
docker images | grep myapp
# Expected output:
# myapp   v2-prod   ...   ~50MB
# myapp   v1        ...   ~151MB
```

### Step 5: Run and verify

```bash
docker run -d --name myapp-prod -p 8080:8080 myapp:v2-prod

curl http://localhost:8080
# Expected output:
# Hello from a production-ready container!

curl http://localhost:8080/health
# Expected output:
# {"status": "ok"}
```

### Step 6: Verify non-root user

```bash
docker exec myapp-prod whoami
# Expected output:
# appuser

docker exec myapp-prod id
# Expected output:
# uid=1000(appuser) gid=1000(appuser) groups=1000(appuser)
```

### Step 7: Check healthcheck status

```bash
# Wait 30 seconds for healthcheck to run
sleep 35
docker ps --filter "name=myapp-prod" --format "{{.Status}}"
# Expected output:
# Up About a minute (healthy)
```

## Validation

```bash
# Image smaller than 100MB
SIZE=$(docker inspect myapp:v2-prod --format='{{.Size}}')
echo "Image size: $((SIZE / 1024 / 1024)) MB"

# Running as non-root
docker exec myapp-prod whoami | grep -q "appuser" && echo "Non-root user OK"

# Health endpoint works
curl -s http://localhost:8080/health | grep -q "ok" && echo "Health check OK"
```

## Cleanup

```bash
docker stop myapp-prod && docker rm myapp-prod
docker rmi myapp:v2-prod myapp:v1 2>/dev/null || true
```

## Extension Task

Add a read-only filesystem:

```bash
docker stop myapp-prod && docker rm myapp-prod
docker run -d --name myapp-ro --read-only -p 8080:8080 myapp:v2-prod
curl http://localhost:8080/health
# Should still work — the app doesn't write to disk
```
