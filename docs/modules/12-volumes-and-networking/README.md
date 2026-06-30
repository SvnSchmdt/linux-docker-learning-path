# Module 12 – Volumes & Networking

## Module Goal

Persist data with Docker volumes and connect containers via Docker networks.

## Why does this matter?

Containers are ephemeral — when you remove one, all data inside it is gone. Volumes solve this. Networks let containers communicate with each other without exposing ports to the host. Both are essential for running multi-service applications.

## Core Concepts

### Bind Mounts vs. Named Volumes

| | Bind Mount | Named Volume |
|---|---|---|
| Path on host | You control (absolute path) | Docker manages (`/var/lib/docker/volumes/`) |
| Syntax | `-v /host/path:/container/path` | `-v myvolume:/container/path` |
| Use case | Dev: share source code | Prod: persist database data |
| Portability | Host-specific | Portable across environments |

### Bind Mounts

Mount a host directory into the container:

```bash
# Mount current directory as /app in container
docker run -v $(pwd):/app node:20-alpine node /app/server.js

# Mount specific directory (read-only)
docker run -v /host/config:/etc/app:ro myapp
```

### Named Volumes

```bash
# Create a volume
docker volume create mydata

# Use in a container
docker run -v mydata:/var/lib/postgresql/data postgres:16

# List volumes
docker volume ls

# Inspect a volume
docker volume inspect mydata

# Remove unused volumes
docker volume prune
```

### Docker Networking

By default, containers on the same network can reach each other by **container name**:

```bash
# Create a network
docker network create mynet

# Run two containers on the same network
docker run -d --name db --network mynet postgres:16
docker run -d --name app --network mynet myapp

# Inside 'app', you can reach 'db' by name:
# psql -h db -U user mydb
```

### Network Types

| Type | Description |
|------|-------------|
| `bridge` (default) | Isolated private network; containers communicate by name |
| `host` | Share host's network stack (no isolation) |
| `none` | No networking |

```bash
docker network ls           # list all networks
docker network inspect mynet  # detailed info
docker network rm mynet     # remove a network
```

## Hands-on Task

1. Create a named volume `pgdata`
2. Start a PostgreSQL container using that volume
3. Create a custom network `appnet`
4. Start a second container on the same network
5. Verify the containers can reach each other

## Example Commands

```bash
# Create named volume
docker volume create pgdata

# Start postgres with named volume
docker run -d \
  --name postgres \
  --network appnet \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine

# Expected: long container ID printed

# List volumes
docker volume ls
# Expected output:
# DRIVER    VOLUME NAME
# local     pgdata

# Inspect network
docker network inspect appnet

# Test container-to-container connectivity
docker run --rm --network appnet alpine ping -c 1 postgres
# Expected output:
# PING postgres (172.18.0.2): 56 data bytes
# 64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.123 ms
```

## Common Mistakes

- **Using bind mounts for database data** — permissions and performance issues; use named volumes for databases
- **Not creating a custom network** — containers on the default bridge can't reach each other by name (only by IP)
- **`docker volume prune` deletes all unused volumes** — including ones with important data; be careful

> [!WARNING]
> `docker volume prune` permanently deletes all volumes not attached to a running container. This includes database data. Use with caution.

## Checkpoint

- [ ] I understand the difference between bind mounts and named volumes
- [ ] I can create and use named volumes
- [ ] I can create a Docker network and connect containers to it
- [ ] Containers on the same network can reach each other by name

## Definition of Done

You can run a database container with persistent data, and a second container can connect to it by name over a Docker network.

## Further Reading

- [docker volume documentation](https://docs.docker.com/storage/volumes/)
- [docker network documentation](https://docs.docker.com/network/)
