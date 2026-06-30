# Module 14 – Registry & Distribution

## Module Goal

Tag, push, and pull Docker images to and from container registries.

## Why does this matter?

An image built on your laptop is useless unless you can get it to a server, a colleague, or a CI/CD pipeline. Registries are the distribution mechanism for container images — like npm for Node packages or PyPI for Python packages, but for Docker images.

## Core Concepts

### Image Naming Convention

```
registry/user/image:tag
│         │    │      └── version or label (default: latest)
│         │    └───────── image name
│         └────────────── username or organization
└──────────────────────── registry hostname (default: docker.io)
```

Examples:
```
nginx:alpine                          → docker.io/library/nginx:alpine
alice/myapp:v1.2.3                    → docker.io/alice/myapp:v1.2.3
ghcr.io/alice/myapp:sha-a1b2c3d       → GitHub Container Registry
registry.example.com/team/app:latest  → private registry
```

### Tagging Images

```bash
# Tag an existing image
docker tag myapp:v1 alice/myapp:v1
docker tag myapp:v1 alice/myapp:latest
docker tag myapp:v1 ghcr.io/alice/myapp:v1
```

### Pushing to Docker Hub

```bash
# Login
docker login

# Push
docker push alice/myapp:v1
docker push alice/myapp:latest
```

### GitHub Container Registry (GHCR)

```bash
# Create a personal access token with 'write:packages' scope
# Then login:
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag and push
docker tag myapp:v1 ghcr.io/alice/myapp:v1
docker push ghcr.io/alice/myapp:v1
```

### Pulling Images

```bash
docker pull nginx:alpine                    # pull specific tag
docker pull nginx                           # pulls :latest
docker pull ghcr.io/alice/myapp:v1          # from GHCR
```

### docker scout (Introduction)

Docker Scout analyzes images for known vulnerabilities:

```bash
docker scout cves nginx:alpine              # check for CVEs
docker scout recommendations nginx:alpine   # suggest better base image
```

## Hands-on Task

1. Build a simple image from the Module 10 example
2. Tag it with your Docker Hub username: `docker tag hello-python:v1 YOUR_USER/hello-python:v1`
3. Push it: `docker push YOUR_USER/hello-python:v1`
4. Pull it on a fresh machine (or remove local image first): `docker pull YOUR_USER/hello-python:v1`

## Example Commands

```bash
# Check which images you have locally
docker images
# Expected output:
# REPOSITORY      TAG    IMAGE ID       CREATED       SIZE
# hello-python    v1     a1b2c3d4e5f6   2 hours ago   151MB

# Tag for Docker Hub
docker tag hello-python:v1 alice/hello-python:v1

# Login (will prompt for password)
docker login

# Push
docker push alice/hello-python:v1
# Expected output:
# The push refers to repository [docker.io/alice/hello-python]
# v1: digest: sha256:abc123... size: 1234

# Remove local image and re-pull to verify
docker rmi alice/hello-python:v1
docker pull alice/hello-python:v1
```

## Common Mistakes

- **Pushing `latest` without a versioned tag** — always tag with a version AND latest; never just latest alone
- **Forgetting to login before push** — `docker push` will fail with "access denied"
- **Not specifying a registry** — without a prefix, Docker assumes Docker Hub

> [!TIP]
> Use semantic versioning for image tags: `v1.0.0`, `v1.0.1`, etc. Using only `latest` makes it impossible to roll back to a specific version.

## Checkpoint

- [ ] I understand the image naming convention (registry/user/image:tag)
- [ ] I can tag an image for Docker Hub or GHCR
- [ ] I can push and pull images
- [ ] I understand why `latest` alone is insufficient

## Definition of Done

You can build an image, tag it correctly, push it to a registry, and pull it again — demonstrating the full distribution workflow.

## Further Reading

- [Docker Hub](https://hub.docker.com/)
- [GitHub Container Registry documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [docker scout documentation](https://docs.docker.com/scout/)
