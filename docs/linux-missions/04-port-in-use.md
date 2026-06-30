# Mission 04 – Port in Use

## Scenario

You're trying to start your web application on port 8080. It fails immediately with:

```
Error starting server: bind: address already in use
```

Something is already sitting on that port. You need to find it.

## Goal

Identify which process owns a port, understand the conflict, and resolve it — without guessing.

## What you will practice

- `ss -tulpen` — list listening sockets with process info
- `lsof -i :PORT` — macOS/Linux alternative
- Connecting process name and PID to a port
- Safe process termination

## Setup

Start a simple listener on port 8080 to simulate the conflict:

```bash
mkdir -p ~/linux-missions/mission-04

# Start a simple Python HTTP server in the background
python3 -m http.server 8080 --directory /tmp &
BLOCKER_PID=$!
echo "Blocker started with PID $BLOCKER_PID" > ~/linux-missions/mission-04/blocker.pid
echo "Port 8080 is now occupied by PID $BLOCKER_PID"
```

## Mission

Your application needs port 8080. It's taken. Find out what's using it.

**Part 1 — Identify the occupant**

```bash
ss -tulpen | grep 8080
```

Expected output (example):

```
tcp  LISTEN 0  5  0.0.0.0:8080  0.0.0.0:*  users:(("python3",pid=12345,fd=4))
```

Questions:

1. What is the process name holding port 8080?
2. What is its PID?
3. What state is the socket in (LISTEN, ESTABLISHED, etc.)?

**Part 2 — Confirm with a second tool**

On Linux:

```bash
lsof -i :8080 2>/dev/null || echo "lsof not available"
```

On macOS:

```bash
lsof -nP -i :8080
```

**Part 3 — Test the conflict yourself**

Try to start another server on port 8080:

```bash
python3 -m http.server 8080 &
```

Expected error (after a moment):

```
OSError: [Errno 98] Address already in use
```

**Part 4 — Resolve the conflict**

You have two options:

Option A — Kill the blocking process:

```bash
kill <PID from Part 1>
```

Option B — Use a different port:

```bash
python3 -m http.server 8081 --directory /tmp &
ss -tulpen | grep 808
```

Choose option A and verify the port is free:

```bash
ss -tulpen | grep 8080
# Expected: (empty — nothing listening)
```

**Bonus:** What does the `users:(...)` section in `ss` output mean? What is `fd=4`?

## Hints

??? hint "Hint 1 – ss flags explained"
    ```
    -t  TCP sockets
    -u  UDP sockets
    -l  listening sockets only
    -p  show process info
    -e  extended info
    -n  show numbers instead of resolving names
    ```

??? hint "Hint 2 – Reading the process info"
    ```
    users:(("python3",pid=12345,fd=4))
    # process name = python3
    # PID = 12345
    # fd = file descriptor number (4 = 4th open file handle)
    ```

??? hint "Hint 3 – Killing the process"
    ```bash
    PID=$(ss -tulpen | grep 8080 | grep -oP 'pid=\K[0-9]+')
    kill "$PID"
    ```

## Validation

```bash
# After killing — port should be free
ss -tulpen | grep 8080
# Expected: (empty)

# Start your own server and confirm it binds
python3 -m http.server 8080 --directory /tmp &
sleep 1
ss -tulpen | grep 8080
# Expected: shows python3 listening on 8080

# Clean up
kill %% 2>/dev/null || pkill -f "http.server 8080"
```

## Cleanup

```bash
pkill -f "http.server 8080" 2>/dev/null || true
pkill -f "http.server 8081" 2>/dev/null || true
rm -rf ~/linux-missions/mission-04
```

## What you should have learned

- `ss -tulpen` is the modern replacement for `netstat -tlnp`
- Every listening socket is owned by a process — you can always find out which one
- Port conflicts are resolved by either killing the occupant or changing your port
- This exact workflow applies when Docker says "port already allocated" — a container or host process is in the way

## Next mission

[Mission 05 – DNS is Broken →](05-dns-is-broken.md)
