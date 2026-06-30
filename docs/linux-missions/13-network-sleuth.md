# Mission 13 – Network Sleuth

## Scenario

A new service was deployed. It's reachable from the server itself but not from outside. The firewall team says "ports are open." The developer says "the app is listening." Nobody can agree on what's actually happening.

## Goal

Systematically verify network reachability layer by layer: is the service listening? Is it on the right interface? Can you reach it locally? Is a firewall blocking it?

## What you will practice

- `ss` and `netstat` — what is listening and on which interface
- `curl` and `wget` — HTTP connectivity testing
- `ping` and `traceroute` — network path verification
- `ip addr` and `ip route` — interface and routing inspection
- `iptables -L` — firewall rules (Linux)
- Loopback vs 0.0.0.0 — binding differences

## Setup

```bash
mkdir -p ~/linux-missions/mission-13

# Start two servers: one on loopback only, one on all interfaces
python3 -m http.server 9001 --bind 127.0.0.1 --directory /tmp &
LOOP_PID=$!

python3 -m http.server 9002 --bind 0.0.0.0 --directory /tmp &
ALL_PID=$!

echo "$LOOP_PID" > ~/linux-missions/mission-13/loop.pid
echo "$ALL_PID" > ~/linux-missions/mission-13/all.pid

sleep 1
echo "Mission 13 setup complete."
echo "Server 1 (loopback-only): http://127.0.0.1:9001"
echo "Server 2 (all interfaces): http://0.0.0.0:9002"
```

## Mission

**Part 1 — List all listening sockets**

```bash
ss -tulpen | grep -E "900[12]"
```

Compare the two entries. Questions:

1. What is the difference between `127.0.0.1:9001` and `0.0.0.0:9002` in the output?
2. Which server would be reachable from another machine on your network?
3. Which server is only reachable from this machine?

**Part 2 — Test local connectivity**

```bash
# Test the loopback-only server locally
curl -s http://127.0.0.1:9001/ | head -5
# Expected: HTML from /tmp

# Test the all-interfaces server locally
curl -s http://127.0.0.1:9002/ | head -5
# Expected: HTML from /tmp
```

Both work locally. Now test via hostname:

```bash
# Get your machine's hostname or local IP
hostname
ip addr show | grep "inet " | grep -v "127.0.0.1"
# or on macOS:
ifconfig | grep "inet " | grep -v "127.0.0.1"
```

**Part 3 — The bind address trap**

```bash
MY_IP=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K[\d.]+' || hostname -I | awk '{print $1}')

# Try reaching loopback-only server via real IP
curl -s http://$MY_IP:9001/ 2>&1 || echo "FAILED as expected"
# Expected: connection refused or timeout

# Try reaching all-interfaces server via real IP
curl -s http://$MY_IP:9002/ | head -3
# Expected: HTML — this works
```

This is the most common "it works on the server but not from outside" bug:

- **`127.0.0.1`** — only localhost can connect
- **`0.0.0.0`** — all interfaces (LAN, WAN, VPN, Docker bridge)

**Part 4 — Inspect your network interfaces**

```bash
ip addr show
```

Fields to read:

- `lo` — loopback (127.0.0.1)
- `eth0` or `ens3` — primary network interface
- `docker0` — Docker bridge (if Docker is installed)

**Part 5 — Routing table**

```bash
ip route
```

Questions:

4. Which interface does traffic to 8.8.8.8 go through?
5. What is your default gateway IP?

```bash
ip route get 8.8.8.8
```

**Part 6 — Check firewall rules (Linux only)**

```bash
sudo iptables -L -n --line-numbers 2>/dev/null || echo "iptables not available or no sudo"
# or
sudo ufw status 2>/dev/null || echo "ufw not available"
```

**Bonus:** When Docker publishes a port with `-p 8080:80`, is it listening on `127.0.0.1:8080` or `0.0.0.0:8080`? Why does this matter for security?

## Hints

??? hint "Hint 1 – Checking bind address quickly"
    ```bash
    ss -tulpen | grep 9001
    # If you see "127.0.0.1:9001" → loopback only
    # If you see "0.0.0.0:9001" or "*:9001" → all interfaces
    ```

??? hint "Hint 2 – Getting your local IP"
    ```bash
    # Linux
    ip route get 1.1.1.1 | grep -oP 'src \K[\d.]+'

    # macOS
    ipconfig getifaddr en0

    # Works on both
    hostname -I 2>/dev/null || ipconfig getifaddr en0 2>/dev/null
    ```

??? hint "Hint 3 – Docker port exposure"
    ```
    By default, Docker publishes ports on 0.0.0.0 (all interfaces).
    To restrict to localhost only: -p 127.0.0.1:8080:80
    This matters: without the restriction, the port is reachable from
    your LAN even if a host firewall would otherwise block it.
    Docker manipulates iptables directly and can bypass ufw rules.
    ```

## Validation

```bash
# Both servers still running
ps aux | grep "http.server" | grep -v grep

# Loopback-only accessible from localhost
curl -s http://127.0.0.1:9001/ > /dev/null && echo "9001 OK"

# All-interfaces accessible from real IP
MY_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1")
curl -s http://$MY_IP:9002/ > /dev/null && echo "9002 OK via $MY_IP"

# Loopback-only NOT accessible from real IP (should fail)
curl -s --max-time 3 http://$MY_IP:9001/ > /dev/null \
  && echo "9001 accessible via IP (unexpected!)" \
  || echo "9001 not accessible via IP (correct!)"
```

## Cleanup

```bash
pkill -f "http.server 9001" 2>/dev/null || true
pkill -f "http.server 9002" 2>/dev/null || true
rm -rf ~/linux-missions/mission-13
```

## What you should have learned

- `127.0.0.1` = only localhost; `0.0.0.0` = all network interfaces
- A service can be listening on a port but still not reachable if it's bound to the wrong interface
- `ss -tulpen` shows you the bind address — this is the first thing to check
- `ip route get <IP>` shows which interface your traffic uses to reach a given destination
- In Docker: port publishing (`-p`) always binds to `0.0.0.0` by default, which bypasses some host firewalls

## Next mission

[Mission 14 – Build a Mini Webserver →](14-build-a-mini-webserver.md)
