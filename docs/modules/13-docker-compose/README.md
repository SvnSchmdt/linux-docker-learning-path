# Module 13 – Docker Compose

## Module Goal

Define and run multi-service applications with Docker Compose.

## Why does this matter?

Real applications rarely run as a single container. A typical web app has a backend, a database, maybe a cache, and a reverse proxy. Docker Compose lets you define all of these as code in a single `docker-compose.yml` file — reproducible, version-controlled, and launchable with one command.

## Core Concepts

### docker-compose.yml Structure

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    depends_on:
      - app

  app:
    build: .
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:

networks:
  default:
    name: myapp-network
```

### image vs. build

```yaml
services:
  web:
    image: nginx:alpine      # pull from registry

  app:
    build: .                 # build from Dockerfile in current dir
    build:
      context: ./app
      dockerfile: Dockerfile.prod  # specify Dockerfile
```

### Essential Commands

```bash
docker compose up           # start all services (foreground)
docker compose up -d        # start in background
docker compose down         # stop and remove containers + networks
docker compose down -v      # also remove volumes
docker compose ps           # list service status
docker compose logs         # all service logs
docker compose logs -f app  # follow logs for one service
docker compose restart app  # restart one service
docker compose exec app bash # shell into running service
docker compose build        # rebuild images
docker compose pull         # pull latest images
```

### .env Files

Docker Compose automatically loads `.env` from the project directory:

```bash
# .env
POSTGRES_PASSWORD=mysecretpassword
APP_PORT=8080
```

```yaml
# docker-compose.yml
services:
  db:
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
  web:
    ports:
      - "${APP_PORT}:80"
```

> [!IMPORTANT]
> Never commit `.env` files with real credentials. Add `.env` to `.gitignore` and provide a `.env.example` with dummy values.

### depends_on

`depends_on` controls start order, but does **not** wait for the service to be ready (only for it to start):

```yaml
services:
  app:
    depends_on:
      db:
        condition: service_healthy  # waits for HEALTHCHECK to pass
```

## Hands-on Task

Create a `docker-compose.yml` with:
1. An nginx service on port 8080
2. A redis service
3. A custom network connecting both

Then run `docker compose up -d`, verify both services are running, and check the nginx response.

## Example

```yaml
# docker-compose.yml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - appnet

  cache:
    image: redis:7-alpine
    networks:
      - appnet

networks:
  appnet:
```

```bash
docker compose up -d

# Expected output:
# [+] Running 3/3
#  ✔ Network demo_appnet    Created
#  ✔ Container demo-cache-1 Started
#  ✔ Container demo-web-1   Started

docker compose ps
# Expected output:
# NAME            IMAGE          STATUS    PORTS
# demo-cache-1    redis:7-alpine Running
# demo-web-1      nginx:alpine   Running   0.0.0.0:8080->80/tcp

docker compose down
```

## Common Mistakes

- **Committing `.env` with real secrets** — use `.env.example` for templates
- **`depends_on` doesn't mean "ready"** — the dependent service may not be accepting connections yet; use healthchecks
- **`docker compose down -v` deletes volumes** — database data is gone; omit `-v` unless you want a clean reset

## Checkpoint

- [ ] I can write a `docker-compose.yml` with multiple services
- [ ] I can use `docker compose up -d` and `docker compose down`
- [ ] I understand how `.env` files work with Compose
- [ ] I know the difference between `depends_on` and a proper healthcheck

## Definition of Done

You can launch a multi-service application with a single `docker compose up -d` and shut it down cleanly with `docker compose down`.

## Further Reading

- [Compose file reference](https://docs.docker.com/compose/compose-file/)
- [docker compose CLI reference](https://docs.docker.com/compose/reference/)
