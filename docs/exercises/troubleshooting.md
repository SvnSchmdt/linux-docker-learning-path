# Troubleshooting Exercises

Broken scenarios to diagnose and fix. Each one has a symptom — figure out the cause and the solution.

## Linux Troubleshooting

**Scenario 1: Permission Denied**

You have a script `deploy.sh` and try to run it:
```
./deploy.sh: Permission denied
```
What do you check first? What's the fix?

<details>
<summary>Solution</summary>

Check permissions: `ls -la deploy.sh`
If output shows `-rw-r--r--`, the file is not executable.
Fix: `chmod +x deploy.sh`
</details>

---

**Scenario 2: Disk Full**

Your application stops writing logs with the error "No space left on device".

What commands do you run to diagnose? How do you find which directory is consuming the most space?

<details>
<summary>Solution</summary>

```bash
df -h          # Find which filesystem is full
du -sh /*      # Top-level space usage
du -sh /var/*  # Drill down into /var
# Usually: /var/log is full of old logs
# Find large log files:
find /var/log -name "*.log" -size +100M
# Rotate or truncate: > /var/log/large.log (truncates to zero)
```
</details>

---

## Docker Troubleshooting

**Scenario 3: Container Exits Immediately**

```bash
docker run myapp
# Container ID printed, then nothing
docker ps
# myapp is not listed
```
How do you find out why?

<details>
<summary>Solution</summary>

```bash
docker ps -a           # shows stopped containers
docker logs <id>       # shows what the process printed before exiting
# Common causes:
# - CMD points to a non-existent file
# - Application crashed (check stack trace in logs)
# - Missing environment variable
```
</details>

---

**Scenario 4: Port Already in Use**

```bash
docker run -p 8080:80 nginx
# Error: ... bind: address already in use
```

How do you find what's using port 8080 and fix it?

<details>
<summary>Solution</summary>

```bash
ss -tlnp | grep 8080   # Find process using port 8080
# or
lsof -i :8080           # macOS alternative

# Options:
# 1. Stop the conflicting process
# 2. Use a different host port: docker run -p 8081:80 nginx
```
</details>

---

**Scenario 5: Container Can't Reach Database**

Your app container logs show:
```
Connection refused: db:5432
```

Both containers are running. What's wrong?

<details>
<summary>Solution</summary>

The containers are probably NOT on the same Docker network, or the container name doesn't match.

```bash
docker inspect app_container | grep Networks
docker inspect db_container | grep Networks
# If different networks: create a shared network and reconnect both
docker network create appnet
docker network connect appnet app_container
docker network connect appnet db_container
```

Also verify the database container name matches what the app expects (`db` in this case).
</details>

---

**Scenario 6: Image Build Fails**

```
ERROR [3/5] RUN pip install -r requirements.txt
...
ERROR: Could not find a version that satisfies the requirement flask==99.0.0
```

What went wrong? How do you fix it?

<details>
<summary>Solution</summary>

The `requirements.txt` specifies a version that doesn't exist (`flask==99.0.0`).
Fix: correct the version in `requirements.txt` (e.g., `flask==3.0.3`).

To find the correct version:
```bash
pip index versions flask  # shows available versions
```
</details>
