# Linux Troubleshooting Flow

A systematic approach to diagnosing Linux problems. Use this when something isn't working and you don't know where to start.

## The Golden Rule

> **Read the exact error message. The error message tells you what is wrong.**

Don't guess. Don't Google before you've read the error. The Linux kernel and standard tools give precise, actionable error messages.

## Universal Diagnostic Flow

```
SYMPTOM
  │
  ├─ Is there an error message? ────► Read it literally
  │                                    - "Permission denied" → check chmod/chown
  │                                    - "No such file or directory" → check paths
  │                                    - "Address already in use" → port conflict
  │                                    - "Connection refused" → service not running / wrong port
  │                                    - "No route to host" → network issue
  │
  ├─ Is a process involved? ──────► ps aux | grep <name>
  │                                  - Not running → check logs, try starting manually
  │                                  - Running → check port, logs, config
  │
  ├─ Is a network port involved? ─► ss -tulpen | grep <port>
  │                                  - Not listening → service not started or wrong port
  │                                  - Listening on 127.0.0.1 → not reachable externally
  │                                  - Listening on 0.0.0.0 → check firewall
  │
  ├─ Is there a config file? ─────► cat <config>; check for typos, wrong values
  │
  └─ Are there logs? ──────────────► tail -f <logfile>; journalctl -u <service> -n 50
```

## By Symptom

### "Command not found"

```bash
which <command>           # Is it installed?
type <command>            # Shell builtin vs external?
echo $PATH                # Is the binary's directory in PATH?
ls /usr/bin | grep <cmd>  # Search installed binaries
```

### "Permission denied"

```bash
ls -la <file>             # Read the permission string
id                        # Who am I? What groups am I in?
stat <file>               # Owner, group, full permissions
sudo -l                   # What can I run with sudo?

# Fix:
chmod <mode> <file>       # Change permissions
chown user:group <file>   # Change owner
```

### "No such file or directory"

```bash
ls <path>                 # Does the parent directory exist?
find / -name <filename>   # Search for the file
file <path>               # What type of file is it?

# Common causes:
# - Typo in path
# - Config references a path that doesn't exist on this machine
# - File was deleted or moved
```

### "Connection refused"

```bash
# 1. Is the service running?
ps aux | grep <service>

# 2. Is it listening on the right port?
ss -tulpen | grep <port>

# 3. Is the port reachable?
curl -v http://host:port/
telnet host port 2>/dev/null || nc -zv host port
```

### "Address already in use"

```bash
ss -tulpen | grep <port>        # Who's using it?
lsof -i :<port> 2>/dev/null     # Alternative
fuser <port>/tcp 2>/dev/null    # Get PID directly

# Fix:
kill <PID>                      # Stop the occupant
# or
# Change your service to use a different port
```

### Service won't start

```bash
# 1. Try running manually
<start command>               # What error appears?

# 2. Check logs
journalctl -u <service> -n 50 --no-pager

# 3. Check config
<service> --config-test 2>/dev/null   # Many services have a config check flag

# 4. Check dependencies
systemctl list-dependencies <service>
```

### App is slow / high load

```bash
top                           # What's consuming CPU?
htop                          # More readable (if installed)
ps aux --sort=-%cpu | head    # Sorted by CPU
ps aux --sort=-%mem | head    # Sorted by memory
vmstat 1 5                    # CPU + memory + I/O every second
iostat -x 1 5                 # Disk I/O (if sysstat installed)
```

### Disk issues

```bash
df -h                         # Filesystem usage
du -sh /*  2>/dev/null        # Top-level directory sizes
du -ah /var | sort -rh | head -20  # Largest files under /var
lsof +L1 2>/dev/null          # Deleted-but-open files (df vs du gap)
```

### DNS not resolving

```bash
nslookup <hostname>           # Basic test
dig <hostname>                # Detailed test
dig @8.8.8.8 <hostname>      # Test against specific resolver
cat /etc/resolv.conf          # Which resolvers?
cat /etc/nsswitch.conf        # Resolution order (files vs dns)
getent hosts <hostname>       # Respects /etc/hosts + nsswitch
```

### SSH problems

```bash
ssh -v user@host              # Verbose — shows exactly what's tried
# Permission denied: check authorized_keys, key permissions
# Timeout: network issue or sshd not running on target
# Host key verification failed: server changed, edit known_hosts
```

## Diagnostic Commands Reference

| Goal | Command |
|------|---------|
| What processes are running? | `ps aux` |
| What's consuming CPU/memory? | `top`, `htop` |
| What's listening on ports? | `ss -tulpen` |
| Who's using this port? | `ss -tulpen \| grep <port>` |
| Disk space? | `df -h` |
| What's taking disk space? | `du -ah / \| sort -rh \| head -20` |
| What's in this file? | `cat`, `less`, `head`, `tail` |
| Find a file? | `find / -name <name>` |
| Search inside files? | `grep -r "pattern" /path` |
| File permissions? | `ls -la`, `stat` |
| What did this service log? | `journalctl -u <service> -n 100` |
| Is DNS working? | `dig google.com` |
| Is a port reachable? | `curl -v http://host:port` |
| Network interfaces? | `ip addr show` |
| Routing table? | `ip route` |
| Traceroute? | `traceroute host` or `tracepath host` |

## The Five-Step Method

When in doubt:

```
1. REPRODUCE  — make the failure happen again on demand
2. ISOLATE    — is it the app, config, permissions, network, or disk?
3. READ       — the exact error message, logs, config values
4. FIX ONE    — fix the first error found, don't fix all at once
5. VERIFY     — confirm the fix worked before moving to the next issue
```

## Related Resources

- [Cheat Sheet](cheat-sheet.md) — quick command reference
- [Glossary](glossary.md) — terminology definitions
- [Linux Missions](../linux-missions/index.md) — practice these skills on real broken scenarios
