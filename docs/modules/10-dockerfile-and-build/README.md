# Module 10 – Dockerfile & Build

## Module Goal

Write a Dockerfile and build a container image using `docker build`.

## Why does this matter?

A Dockerfile is the recipe for your application's runtime environment. Instead of documenting "install these 7 packages and then run these 3 commands," you write a Dockerfile. The resulting image can be run identically on any machine with Docker — developer laptops, CI servers, production hosts.

## Core Concepts

### Dockerfile Instructions

```dockerfile
FROM python:3.12-slim           # base image — always first
WORKDIR /app                    # set working directory
COPY requirements.txt .         # copy files from build context
RUN pip install -r requirements.txt  # run commands during build
COPY . .                        # copy rest of app
ENV PORT=8080                   # set environment variable
EXPOSE 8080                     # document which port the app uses
CMD ["python", "app.py"]        # default command to run
```

**Key instructions explained:**

| Instruction | Purpose |
|-------------|---------|
| `FROM` | Base image to build on — must be first |
| `WORKDIR` | Sets the working directory for subsequent instructions |
| `COPY` | Copy files from build context into image |
| `ADD` | Like COPY but also handles URLs and .tar files (prefer COPY) |
| `RUN` | Execute commands in a new layer |
| `ENV` | Set environment variable (persists into container) |
| `EXPOSE` | Document which port the container listens on |
| `CMD` | Default command when container starts (overridable) |
| `ENTRYPOINT` | Fixed command; CMD becomes arguments (harder to override) |

### Layer Caching

Each instruction creates a new **layer**. Docker caches layers — if nothing changed, it reuses the cached layer:

```dockerfile
FROM python:3.12-slim
WORKDIR /app

# Copy requirements FIRST — this layer is rarely invalidated
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy source code LAST — this changes often
COPY . .

CMD ["python", "app.py"]
```

If you copy the entire source code first (`COPY . .`) and then install dependencies, every code change invalidates the pip install cache.

### .dockerignore

Like `.gitignore` — tells Docker what NOT to include in the build context:

```
.git
.venv
__pycache__
*.pyc
.env
node_modules
```

### Building Images

```bash
docker build -t myapp:v1 .              # build with tag, using current dir
docker build -t myapp:v1 -f Dockerfile.prod .  # use specific Dockerfile
docker build --no-cache -t myapp:v1 .   # ignore cache
```

## Hands-on Task

Create a simple app and build a Docker image:

1. Create `app.py`:
```python
print("Hello from Docker!")
```

2. Create `Dockerfile`:
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]
```

3. Build and run:
```bash
docker build -t hello-python:v1 .
docker run hello-python:v1
```

## Example Commands

```bash
# Build an image tagged myapp:v1 from current directory
docker build -t myapp:v1 .

# Expected output (abbreviated):
# [+] Building 12.3s (8/8) FINISHED
#  => [internal] load build definition from Dockerfile
#  => [1/4] FROM python:3.12-slim
#  => [2/4] WORKDIR /app
#  => [3/4] COPY app.py .
#  => [4/4] CMD ["python", "app.py"]

# List images to see your new image
docker images
# Expected output:
# REPOSITORY      TAG    IMAGE ID       CREATED         SIZE
# hello-python    v1     a1b2c3d4e5f6   2 seconds ago   151MB
```

## Common Mistakes

- **Wrong instruction order** — put rarely-changing instructions first to maximize cache hits
- **`COPY . .` before `pip install`** — invalidates the install cache on every code change
- **No `.dockerignore`** — sends `.git`, `node_modules`, or virtual environments to the build daemon
- **Using `ADD` when `COPY` is sufficient** — `ADD` has surprising behavior; prefer `COPY` for simple file copying

## Checkpoint

- [ ] I can write a Dockerfile with FROM, WORKDIR, COPY, RUN, and CMD
- [ ] I understand how layer caching works and how to optimize for it
- [ ] I can build an image with a tag using `docker build -t`
- [ ] I have a `.dockerignore` in place

## Definition of Done

You can write a Dockerfile for a simple application, build it, and explain why instruction order matters for caching.

## Further Reading

- [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
