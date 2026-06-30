# Module 15 – Production Patterns

## Module Goal

Apply security and efficiency patterns for production-ready Docker images.

## Why does this matter?

A Dockerfile that works locally is not necessarily production-ready. Production images need to be small (faster pulls, smaller attack surface), secure (no root, no unnecessary packages), and observable (healthchecks). These patterns are standard in professional container workflows.

## Core Concepts

### Multi-Stage Builds

Build in one stage, copy only the result to the final image:

```dockerfile
# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Runtime (no build tools, no source code)
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /build/dist ./dist
COPY --from=builder /build/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

The runtime image contains no build tools, no source code, no dev dependencies — much smaller and more secure.

### Minimal Base Images

| Base image | Typical size | Use case |
|------------|-------------|----------|
| `ubuntu:24.04` | ~78 MB | General purpose |
| `debian:bookworm-slim` | ~75 MB | Debian-based apps |
| `python:3.12-slim` | ~130 MB | Python apps |
| `python:3.12-alpine` | ~23 MB | Python (no glibc) |
| `node:20-alpine` | ~140 MB | Node.js apps |
| `gcr.io/distroless/python3` | ~50 MB | Python (no shell) |
| `scratch` | 0 MB | Static binaries only |

Alpine-based images use musl libc instead of glibc — compatible with most apps, but verify for native extensions.

### Non-Root User

Never run application processes as root inside a container:

```dockerfile
FROM python:3.12-slim
WORKDIR /app

# Create non-root user
RUN useradd --create-home --no-log-init appuser

COPY --chown=appuser:appuser . .
RUN pip install --no-cache-dir -r requirements.txt

USER appuser
CMD ["python", "app.py"]
```

### HEALTHCHECK

Tells Docker (and orchestrators) how to check if the app is healthy:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

```bash
# See healthcheck status
docker ps
# CONTAINER ID  ...  STATUS
# abc123        ...  Up 2 minutes (healthy)
```

### Read-Only Filesystem

```bash
docker run --read-only myapp
# If the app needs to write, use a tmpfs for /tmp:
docker run --read-only --tmpfs /tmp myapp
```

### .dockerignore Matters

```
.git/
.github/
.venv/
node_modules/
*.md
.env
.DS_Store
__pycache__/
*.pyc
tests/
docs/
```

## Hands-on Task

Take the image from Module 10 and improve it:
1. Add a non-root user
2. Switch to `python:3.12-alpine` as base image
3. Add a `HEALTHCHECK`
4. Compare image sizes before and after

## Example

```dockerfile
FROM python:3.12-alpine
WORKDIR /app

RUN adduser --disabled-password --no-create-home appuser

COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser . .

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:8080/health || exit 1

USER appuser
EXPOSE 8080
CMD ["python", "app.py"]
```

```bash
# Compare sizes
docker images | grep myapp
# Expected output:
# myapp    v1-before   ...   151MB
# myapp    v2-after    ...    58MB
```

## Common Mistakes

- **Running as root** — if the app is compromised, the attacker has root in the container
- **Not pinning base image versions** — `FROM python:3.12-slim` is reproducible; `FROM python:latest` is not
- **`RUN apt-get install` without cleanup** — always chain with `rm -rf /var/lib/apt/lists/*` to keep layer small

> [!IMPORTANT]
> Always pin your base image version. `FROM nginx:1.25-alpine` will give you the same image every build. `FROM nginx:latest` might not.

## Checkpoint

- [ ] I can write a multi-stage Dockerfile
- [ ] I can add a non-root user to a Dockerfile
- [ ] I can add a `HEALTHCHECK` instruction
- [ ] I understand why minimal base images matter

## Definition of Done

You can take a basic Dockerfile and improve it for production: smaller base image, multi-stage build, non-root user, and healthcheck.

## Further Reading

- [Docker security best practices](https://docs.docker.com/develop/security-best-practices/)
- [distroless images](https://github.com/GoogleContainerTools/distroless)
- [docker scout](https://docs.docker.com/scout/)
