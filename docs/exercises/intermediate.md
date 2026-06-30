# Intermediate Exercises

Complete these after Modules 05–13.

## Processes & System

**Exercise 1:** Start three `sleep` processes in the background (e.g. `sleep 300`). List them with `ps aux | grep sleep`. Kill them all with one `pkill` command.

**Exercise 2:** Find which process is listening on port 8080 on your machine (if any). Use `ss` or `lsof`.

**Exercise 3:** Write a script that monitors disk usage of `/tmp` every 5 seconds and exits when it exceeds 80% (use `df` and a `while` loop).

## Shell Scripting

**Exercise 4:** Write a script `check-ports.sh` that takes a hostname as argument and checks if ports 80 and 443 are reachable (use `curl --connect-timeout 3`).

**Exercise 5:** Write a script that finds all `.log` files in a given directory, prints their names and sizes, and deletes files older than 7 days.

## Docker

**Exercise 6:** Pull the `alpine:3.19` image. Run a container that prints `Hello from Alpine` and then exits. Verify the container status with `docker ps -a`.

**Exercise 7:** Write a Dockerfile for a Node.js app that:
- Uses `node:20-alpine` as base
- Sets WORKDIR to `/app`
- Creates a non-root user
- Has a CMD of `["node", "-e", "console.log('Hello Node')"]`

Build it, run it, verify the output.

**Exercise 8:** Run a PostgreSQL container with:
- Name: `mydb`
- Port: `5432:5432`
- Environment: `POSTGRES_PASSWORD=testpass`, `POSTGRES_DB=myapp`
- Named volume: `pgdata:/var/lib/postgresql/data`

Connect to it using `docker exec -it mydb psql -U postgres myapp` and create a table.

## Docker Compose

**Exercise 9:** Write a `docker-compose.yml` that starts:
- `wordpress:6` on port 8080
- `mysql:8` with a password and database
- A named volume for MySQL data

Verify WordPress is accessible at `http://localhost:8080`.

**Exercise 10:** Add a healthcheck to the MySQL service using `mysqladmin ping`. Make WordPress depend on MySQL with `condition: service_healthy`.

---

**Cleanup:** `docker compose down -v` and `docker rm -f mydb`
