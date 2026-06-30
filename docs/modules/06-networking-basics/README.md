# Module 06 – Networking Basics

## Module Goal

Test network connectivity, make HTTP requests, and use SSH from the command line.

## Why does this matter?

Modern systems communicate over networks constantly. Whether you're debugging a web service, connecting to a remote server, or testing if a container can reach the internet, you need a small set of network tools. These are also essential for understanding how Docker networking works later.

## Core Concepts

### HTTP Requests with curl

```bash
curl https://example.com                    # GET request
curl -I https://example.com                 # headers only
curl -o output.html https://example.com     # save to file
curl -X POST -d '{"key":"val"}' -H 'Content-Type: application/json' https://api.example.com/
curl -v https://example.com                 # verbose (shows request + response headers)
```

### Downloading Files

```bash
wget https://example.com/file.tar.gz        # download file
curl -L -O https://example.com/file.tar.gz  # curl equivalent (-L follows redirects)
```

### Connectivity Testing

```bash
ping google.com         # test connectivity (Ctrl+C to stop)
ping -c 4 google.com    # send exactly 4 packets
```

### Port and Socket Info

```bash
ss -tlnp            # listening TCP ports and which process owns them
ss -tunp            # all TCP/UDP connections
netstat -tlnp       # older equivalent (may not be installed)
```

### DNS Lookup

```bash
nslookup google.com         # query DNS
dig google.com              # detailed DNS query
dig google.com A            # only A records (IPv4)
cat /etc/hosts              # local hostname overrides
```

### SSH — Secure Shell

```bash
ssh user@hostname                   # connect to remote host
ssh -p 2222 user@hostname           # non-standard port
ssh -i ~/.ssh/id_rsa user@hostname  # specific key file
scp file.txt user@host:/remote/path # copy file to remote
scp user@host:/remote/file.txt .    # copy file from remote
```

### Understanding Ports and Protocols

Common ports to know:

| Port | Protocol |
|------|----------|
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 3306 | MySQL |
| 5432 | PostgreSQL |
| 6379 | Redis |
| 8080 | Common HTTP alternative |

## Hands-on Task

1. Fetch the HTTP headers from `https://example.com` using `curl -I`
2. Find out which ports are listening on your machine: `ss -tlnp`
3. Look up the A record for `docs.docker.com` using `dig`
4. Check your `/etc/hosts` file

## Example Commands

```bash
# Check if a web server is responding
curl -I https://example.com
# Expected output (truncated):
# HTTP/2 200
# content-type: text/html; charset=UTF-8
# ...

# Test if port 443 is open on a host
curl -v --connect-timeout 5 https://google.com 2>&1 | head -5

# Find what's listening on port 8080
ss -tlnp | grep 8080

# DNS lookup
dig google.com +short
# Expected output:
# 142.250.185.46

# View /etc/hosts
cat /etc/hosts
# Expected output (macOS):
# 127.0.0.1       localhost
# 255.255.255.255 broadcasthost
# ::1             localhost
```

## Common Mistakes

- **`ping` blocked by firewalls** — ping is often blocked; use `curl` or `nc` to test connectivity instead
- **`curl` vs `wget`** — both download files, but `curl` is more versatile for API testing
- **SSH key permissions** — your private key must be `chmod 600` or SSH will refuse to use it

> [!TIP]
> `curl -v` is your best friend when debugging HTTP — it shows every header sent and received.

## Checkpoint

- [ ] I can make HTTP requests with `curl` and inspect headers
- [ ] I can check which ports are in use with `ss`
- [ ] I can look up DNS records with `dig` or `nslookup`
- [ ] I can connect to a remote server with SSH

## Definition of Done

You can debug basic network connectivity issues: test if a host is reachable, what port it's listening on, and what DNS returns for a hostname.

## Further Reading

- `man curl`
- `man ssh`
- `man dig`
- `man ss`
