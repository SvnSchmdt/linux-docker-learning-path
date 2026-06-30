# Mission 05 – DNS is Broken

## Scenario

Your application can't reach the database server. The error message says:

```
connection refused: could not resolve hostname "db.internal"
```

But the DBA insists the database is running. You suspect DNS. Prove it — or disprove it.

## Goal

Diagnose DNS resolution failures, understand the resolution chain, and use manual workarounds to test connectivity independently of DNS.

## What you will practice

- `nslookup` and `dig` — query DNS resolvers
- `/etc/resolv.conf` — understand how resolvers are configured
- `/etc/hosts` — manual hostname overrides
- `ping` vs DNS (ICMP != DNS)
- `curl` with explicit IP

## Setup

No script required. This mission uses your local system's DNS and `/etc/hosts`.

```bash
mkdir -p ~/linux-missions/mission-05
echo "Mission 05 ready — no external setup needed."
```

## Mission

**Part 1 — Reproduce the failure**

Try to resolve a hostname that doesn't exist:

```bash
nslookup db.internal
```

Expected output:

```
** server can't find db.internal: NXDOMAIN
```

`NXDOMAIN` means "Non-Existent Domain" — the resolver returned definitively: this hostname does not exist.

**Part 2 — Understand your resolver**

Check how your system resolves names:

```bash
cat /etc/resolv.conf
```

Expected output (varies by system):

```
nameserver 127.0.0.53
search example.com
```

Questions:

1. What IP is your nameserver?
2. What does the `search` directive do?
3. What is the difference between DNS resolution and `/etc/hosts`?

**Part 3 — Check the resolution order**

```bash
cat /etc/nsswitch.conf | grep "^hosts"
```

Expected output:

```
hosts: files dns mymachines
```

This tells the system: check `/etc/hosts` first, then DNS. This matters.

**Part 4 — Simulate a DNS fix with /etc/hosts**

In a real environment, you might be waiting for DNS propagation but need to test now. Add a manual override:

```bash
grep "db.internal" /etc/hosts || echo "Not in /etc/hosts"

# Add the entry (requires sudo)
echo "127.0.0.1  db.internal" | sudo tee -a /etc/hosts

# Verify resolution works now
nslookup db.internal
# Expected: Address: 127.0.0.1
```

**Part 5 — Use dig for detailed diagnostics**

```bash
dig google.com
```

Read the output:

- `ANSWER SECTION` — the resolved IP(s)
- `Query time` — how fast was the response?
- `SERVER` — which DNS server answered?

```bash
dig @8.8.8.8 google.com
# Forces resolution via Google's public DNS regardless of /etc/resolv.conf
```

**Part 6 — Test connectivity independent of DNS**

If you have an IP, you can test connectivity without DNS:

```bash
curl -v http://127.0.0.1:80 2>&1 | head -20
# Expected: connection refused (no server on 80) — but DNS is not involved
```

This is how you prove "DNS works but connection fails" vs "DNS itself is broken".

**Bonus:** What is the difference between `nslookup` and `dig`? Why do sysadmins prefer `dig`?

## Hints

??? hint "Hint 1 – Reading /etc/resolv.conf"
    ```
    nameserver 127.0.0.53   ← systemd-resolved stub resolver
    search home.local        ← appended to bare hostnames (so "db" becomes "db.home.local")
    ```

??? hint "Hint 2 – Adding a hosts entry"
    ```bash
    # Format: IP  hostname  [aliases]
    echo "192.168.1.100  db.internal db" | sudo tee -a /etc/hosts
    # Verify
    getent hosts db.internal
    ```

??? hint "Hint 3 – When /etc/hosts is ignored"
    ```bash
    cat /etc/nsswitch.conf | grep hosts
    # If "dns" comes before "files", hosts file is checked second
    # This is rare but happens on misconfigured systems
    ```

## Validation

```bash
# Confirm /etc/hosts entry exists
grep "db.internal" /etc/hosts
# Expected: 127.0.0.1  db.internal

# Confirm resolution works
getent hosts db.internal
# Expected: 127.0.0.1    db.internal

# Confirm a real domain resolves
dig +short google.com | head -3
# Expected: one or more IP addresses
```

## Cleanup

```bash
# Remove the hosts entry we added
sudo sed -i.bak '/db\.internal/d' /etc/hosts

# Verify it's gone
grep "db.internal" /etc/hosts && echo "NOT REMOVED" || echo "Cleaned up"

rm -rf ~/linux-missions/mission-05
```

## What you should have learned

- `NXDOMAIN` = hostname doesn't exist in DNS; `SERVFAIL` = resolver couldn't reach upstream
- `/etc/hosts` is checked before DNS (by default) and can override any DNS entry
- `dig` gives more detail than `nslookup` and is the preferred diagnostic tool
- You can always bypass DNS by using an IP address directly — useful for isolating network vs DNS issues
- In Docker: each container has its own `/etc/resolv.conf` pointing to Docker's embedded DNS at `127.0.0.11`

## Next mission

[Mission 06 – Service Won't Start →](06-service-wont-start.md)
