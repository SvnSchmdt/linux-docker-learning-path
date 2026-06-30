# Mission 09 – SSH Key Trouble

## Scenario

You've been handed credentials to a new server. The private key is in a file. SSH says:

```
Permission denied (publickey).
```

Or worse, it doesn't even try the key — it just asks for a password. You need to diagnose the problem.

## Goal

Understand SSH key authentication from end to end: generate keys, configure them correctly, set permissions, and debug when it fails.

## What you will practice

- `ssh-keygen` — key generation
- `ssh-copy-id` — deploying public keys
- Correct permissions for `~/.ssh/` and key files
- `ssh -v` — verbose debugging
- `authorized_keys` format

## Setup

```bash
mkdir -p ~/linux-missions/mission-09
cd ~/linux-missions/mission-09

# Create a test SSH directory to work with
mkdir -p test-ssh-dir
echo "We'll simulate SSH config issues in test-ssh-dir/"
```

## Mission

**Part 1 — Generate a key pair**

```bash
ssh-keygen -t ed25519 -C "mission-09-test" -f ~/linux-missions/mission-09/test-ssh-dir/id_ed25519 -N ""
```

This creates:
- `id_ed25519` — private key (NEVER share this)
- `id_ed25519.pub` — public key (safe to share)

Look at both:

```bash
cat ~/linux-missions/mission-09/test-ssh-dir/id_ed25519.pub
# Starts with: ssh-ed25519 AAAA...

head -3 ~/linux-missions/mission-09/test-ssh-dir/id_ed25519
# Starts with: -----BEGIN OPENSSH PRIVATE KEY-----
```

Questions:

1. What algorithm was used?
2. Why is ed25519 preferred over RSA 2048?
3. What does the `-N ""` flag do?

**Part 2 — Understand the permissions requirement**

SSH will refuse to use a private key with wrong permissions. Try this:

```bash
# Copy key to /tmp for testing
cp ~/linux-missions/mission-09/test-ssh-dir/id_ed25519 /tmp/test_key

# Give it overly broad permissions
chmod 644 /tmp/test_key
ls -la /tmp/test_key

# Try using it (will fail on a real SSH, but observe the error)
ssh -i /tmp/test_key -v nonexistent@localhost 2>&1 | grep -i "perm\|bad\|warn" || true
# Expected warning: "Permissions 0644 for '/tmp/test_key' are too open"
```

Fix it:

```bash
chmod 600 /tmp/test_key
ls -la /tmp/test_key
```

Permission rules for SSH:

| Path | Correct permission |
|------|-------------------|
| `~/.ssh/` | `700` (drwx------) |
| `~/.ssh/id_ed25519` | `600` (-rw-------) |
| `~/.ssh/id_ed25519.pub` | `644` (-rw-r--r--) |
| `~/.ssh/authorized_keys` | `600` (-rw-------) |
| `~/.ssh/config` | `600` (-rw-------) |

**Part 3 — The authorized_keys file**

When you SSH into a server, the server checks if your public key is in `~/.ssh/authorized_keys`. Simulate this:

```bash
mkdir -p ~/linux-missions/mission-09/fake-server/.ssh
chmod 700 ~/linux-missions/mission-09/fake-server/.ssh

# "Deploy" the public key
cat ~/linux-missions/mission-09/test-ssh-dir/id_ed25519.pub \
  >> ~/linux-missions/mission-09/fake-server/.ssh/authorized_keys
chmod 600 ~/linux-missions/mission-09/fake-server/.ssh/authorized_keys

cat ~/linux-missions/mission-09/fake-server/.ssh/authorized_keys
```

**Part 4 — Debug with verbose SSH**

When SSH fails, `-v` (or `-vvv` for maximum verbosity) shows exactly what's happening:

```bash
ssh -v -i /tmp/test_key localhost 2>&1 | head -40
# Look for lines like:
# "Offering public key: ..."
# "Server accepts key: ..."
# "Permission denied"
```

The verbose output tells you whether the key was offered, accepted, or rejected.

**Part 5 — Common failure checklist**

Work through this mental checklist when SSH key auth fails:

1. Is the private key present? `ls -la ~/.ssh/`
2. Is the private key permission `600`? `stat -c "%a" ~/.ssh/id_ed25519`
3. Is `~/.ssh/` permission `700`? `stat -c "%a" ~/.ssh/`
4. Is the public key in `~/.ssh/authorized_keys` on the server?
5. Is `authorized_keys` permission `600` on the server?
6. Did the SSH server's `sshd_config` allow public key auth? (`PubkeyAuthentication yes`)

**Bonus:** What is an SSH config file (`~/.ssh/config`)? Write one entry that specifies a custom key for a specific host.

## Hints

??? hint "Hint 1 – Checking your local key setup"
    ```bash
    ls -la ~/.ssh/
    # You want:
    # drwx------ .ssh/
    # -rw------- id_ed25519
    # -rw-r--r-- id_ed25519.pub
    ```

??? hint "Hint 2 – SSH config file"
    ```
    Host myserver
      HostName 192.168.1.100
      User alice
      IdentityFile ~/.ssh/id_ed25519
      Port 22
    ```
    Save to `~/.ssh/config` with `chmod 600`.

??? hint "Hint 3 – Fixing permissions in one command"
    ```bash
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_ed25519 ~/.ssh/authorized_keys ~/.ssh/config 2>/dev/null
    chmod 644 ~/.ssh/id_ed25519.pub
    ```

## Validation

```bash
# Key files exist
ls -la ~/linux-missions/mission-09/test-ssh-dir/
# Expected: id_ed25519 and id_ed25519.pub

# Public key format
head -1 ~/linux-missions/mission-09/test-ssh-dir/id_ed25519.pub
# Expected: starts with "ssh-ed25519"

# authorized_keys contains the public key
cat ~/linux-missions/mission-09/fake-server/.ssh/authorized_keys | wc -l
# Expected: 1

# Correct permissions
stat -c "%a" ~/linux-missions/mission-09/fake-server/.ssh/authorized_keys 2>/dev/null \
  || stat -f "%Mp%Lp" ~/linux-missions/mission-09/fake-server/.ssh/authorized_keys
# Expected: 600
```

## Cleanup

```bash
rm -f /tmp/test_key
rm -rf ~/linux-missions/mission-09
```

## What you should have learned

- SSH key authentication relies on private key (client), public key (server), and correct permissions on both
- `600` for private keys and `700` for `~/.ssh/` are not optional — SSH refuses to use looser permissions
- `ssh -v` shows exactly which keys were tried and why auth failed
- `~/.ssh/authorized_keys` is the server-side file that permits specific public keys
- In Docker: you mount SSH agent sockets or keys as secrets for builds that need to clone private repos — same permission rules apply

## Next mission

[Mission 10 – Cron Did Not Run →](10-cron-did-not-run.md)
