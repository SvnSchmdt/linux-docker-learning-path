# Checkpoints

Self-assessment tests to confirm you're ready for the next phase.

## Checkpoint 1 – Linux Basics

You should be able to complete these tasks without help:

- [ ] Navigate to `/etc`, list all files, and find a file containing the word "hosts"
- [ ] Create a directory `~/projects/demo`, create a file `notes.txt` in it, and write a line to it using `echo` and redirection
- [ ] Set permissions on `notes.txt` to `644` and explain what that means
- [ ] Find all `.conf` files under `/etc` (non-recursively) and count how many there are
- [ ] Start a background process (`sleep 60 &`) and kill it by PID
- [ ] Write a script that loops from 1 to 5 and prints each number

## Checkpoint 2 – Container Basics

- [ ] Explain the difference between an image and a container in one sentence
- [ ] Pull the `nginx:alpine` image and start a container on port 8080
- [ ] Write a Dockerfile for a simple Python app that prints "Hello"
- [ ] Build and tag the image as `myapp:v1`
- [ ] Read the logs of a running container
- [ ] Execute a command inside a running container with `docker exec`

## Checkpoint 3 – Production-Ready

- [ ] Write a `docker-compose.yml` with a web app and a Redis service, connected via a named network
- [ ] Add a named volume for Redis persistence
- [ ] Push a tagged image to Docker Hub (or GHCR)
- [ ] Write a multi-stage Dockerfile and compare image sizes
- [ ] Add a non-root user to a Dockerfile
- [ ] Add a `HEALTHCHECK` instruction to a Dockerfile

> [!TIP]
> If you can complete all tasks in a checkpoint, you're genuinely ready for the next phase — not just "I read about it" ready.
