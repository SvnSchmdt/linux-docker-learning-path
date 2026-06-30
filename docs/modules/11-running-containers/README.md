# Module 11 – Running Containers

## Module Goal

Start, inspect, manage, and debug running containers.

## Why does this matter?

Building an image is only half the work. You need to know how to run containers correctly — with the right flags for networking, environment, and resource control — and how to inspect and debug them when things go wrong.

## Core Concepts

### docker run Flags

```bash
docker run nginx                          # foreground, blocks terminal
docker run -d nginx                       # detached (background)
docker run -it ubuntu bash                # interactive terminal
docker run --rm nginx                     # remove container on exit
docker run -p 8080:80 nginx              # port mapping: host:container
docker run -e PORT=8080 myapp            # pass environment variable
docker run --name my-nginx nginx         # assign a name
docker run -d --name web -p 8080:80 nginx  # combine multiple flags
```

### Listing and Inspecting

```bash
docker ps                    # running containers
docker ps -a                 # all containers (including stopped)
docker inspect container-id  # full JSON details
docker inspect -f '{{ .NetworkSettings.IPAddress }}' container-id  # format output
```

### Logs

```bash
docker logs container-id           # all logs
docker logs -f container-id        # follow (like tail -f)
docker logs --tail 50 container-id # last 50 lines
docker logs --since 5m container-id # logs from last 5 minutes
```

### Executing Commands Inside a Container

```bash
docker exec container-id ls /app          # run a single command
docker exec -it container-id bash         # interactive shell
docker exec -it container-id sh           # if bash is not available
docker exec -it -e DEBUG=1 container-id bash  # with env var
```

### Stopping and Removing

```bash
docker stop container-id        # SIGTERM + wait 10s + SIGKILL
docker stop -t 30 container-id  # wait 30s before force kill
docker kill container-id        # immediate SIGKILL
docker rm container-id          # remove stopped container
docker rm -f container-id       # force remove running container
docker container prune          # remove ALL stopped containers
```

## Hands-on Task

1. Start an nginx container in the background on port 8080: `docker run -d --name web -p 8080:80 nginx`
2. Verify it's running: `curl http://localhost:8080`
3. Read the logs: `docker logs web`
4. Open a shell inside it: `docker exec -it web bash`
5. Stop and remove it: `docker stop web && docker rm web`

## Example Commands

```bash
# Start nginx in background with port mapping
docker run -d --name web -p 8080:80 nginx

# Expected output:
# 3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d

# Check it's running
docker ps
# Expected output:
# CONTAINER ID   IMAGE   COMMAND                  PORTS                  NAMES
# 3a4b5c6d7e8f   nginx   "/docker-entrypoint.…"   0.0.0.0:8080->80/tcp   web

# Test the web server
curl http://localhost:8080
# Expected output:
# <!DOCTYPE html>
# <html>
# <head><title>Welcome to nginx!</title></head>
# ...

# Open interactive shell
docker exec -it web bash
# You are now inside the container:
# root@3a4b5c6d7e8f:/#

# Stop and clean up
docker stop web && docker rm web
```

## Common Mistakes

- **Forgetting `-d`** — the container runs in the foreground and blocks your terminal
- **Port already in use** — check with `ss -tlnp | grep 8080` before running
- **Container exits immediately** — often because the main process failed; check `docker logs`
- **`docker rm` on a running container** — use `docker rm -f` or stop it first

> [!TIP]
> Use `--rm` when experimenting: `docker run --rm -it ubuntu bash`. The container is automatically removed when you exit.

## Checkpoint

- [ ] I can run a container in detached mode with port mapping
- [ ] I can read container logs with `docker logs`
- [ ] I can open an interactive shell inside a running container
- [ ] I can stop and remove containers

## Definition of Done

You can run a web server in a Docker container, verify it works, inspect its logs, open a debugging shell inside it, and clean up afterwards.

## Further Reading

- `docker run --help`
- [docker run reference](https://docs.docker.com/engine/reference/commandline/run/)
