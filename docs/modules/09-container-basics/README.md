# Module 09 – Container Basics

## Module Goal

Understand what containers are, how they differ from virtual machines, and why they exist.

## Why does this matter?

Containers are the foundation of modern software deployment. Before you run a single `docker` command, you need to understand *what* you're actually working with — otherwise you'll memorize commands without understanding them. This conceptual foundation prevents many common mistakes.

## Core Concepts

### Container vs. Virtual Machine

| | Virtual Machine | Container |
|---|---|---|
| Isolation | Full OS + hardware virtualization | Process-level (shared kernel) |
| Startup time | Minutes | Milliseconds |
| Size | Gigabytes | Megabytes |
| Overhead | High | Low |
| Use case | Full OS isolation | Application isolation |

A container is **not** a VM. It is an isolated process running on the host kernel, using Linux kernel features to appear isolated.

### How Containers Work

Two kernel features make containers possible:

**Namespaces** — provide isolation:
- `pid` — process IDs (container can't see host processes)
- `net` — network interfaces (container has its own IP)
- `mnt` — filesystem mount points
- `uts` — hostname
- `user` — user IDs

**cgroups (control groups)** — limit resources:
- CPU usage
- Memory usage
- I/O bandwidth

Together: a container process thinks it's alone on the system and has its own network, filesystem, and PIDs.

### Image vs. Container

| Image | Container |
|-------|----------|
| Read-only template | Running instance of an image |
| Like a class definition | Like an object/instance |
| Stored on disk | Lives in memory while running |
| Created with `docker build` | Created with `docker run` |

### OCI Standard

The **Open Container Initiative (OCI)** defines:
- **Image spec** — how container images are structured and stored
- **Runtime spec** — how container runtimes must behave

This is why Docker images work with Podman, containerd, and Kubernetes — they all implement the OCI spec.

### Docker vs. Podman

| | Docker | Podman |
|---|---|---|
| Architecture | Daemon-based | Daemonless |
| Root required | Historically yes | No (rootless) |
| Compatibility | OCI-compliant | OCI-compliant |
| Compose | Docker Compose | Podman Compose |

For this learning path, we use Docker. The concepts transfer directly to Podman.

### Container Lifecycle

```
Image (on disk)
    ↓ docker run
Container (created)
    ↓ process starts
Container (running)
    ↓ process exits / docker stop
Container (stopped)
    ↓ docker rm
Container (deleted)
```

## Hands-on Task

1. Run `docker info` and find the storage driver and number of running containers
2. Pull the `hello-world` image: `docker pull hello-world`
3. Run it: `docker run hello-world`
4. Look at what happened: `docker ps -a`

## Example Commands

```bash
# Check Docker is working
docker info

# Pull an image
docker pull hello-world

# Run a container from that image
docker run hello-world

# Expected output (abbreviated):
# Hello from Docker!
# This message shows that your installation appears to be working correctly.

# See all containers (including stopped)
docker ps -a
# Expected output:
# CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     NAMES
# a1b2c3d4e5f6   hello-world   "/hello"   5 seconds ago   Exited (0) 5 seconds ago   friendly_newton

# List local images
docker images
```

## Common Mistakes

- **Thinking containers are VMs** — containers share the host kernel; they don't run a full OS
- **Confusing image and container** — you run containers FROM images; the image doesn't change
- **Thinking a stopped container is gone** — `docker ps -a` shows stopped containers; they still exist until `docker rm`

## Checkpoint

- [ ] I can explain the difference between a container and a VM
- [ ] I can explain the difference between an image and a container
- [ ] I know what namespaces and cgroups do (conceptually)
- [ ] I understand the OCI standard and why it matters

## Definition of Done

You can explain to someone what a container is — without saying "it's like a VM but lighter."

## Further Reading

- [Docker documentation: What is a container?](https://docs.docker.com/get-started/overview/)
- [OCI Image Spec](https://github.com/opencontainers/image-spec)
