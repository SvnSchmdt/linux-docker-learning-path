# Module 05 – Processes & System

## Module Goal

Monitor running processes, manage system services, and check system resource usage.

## Why does this matter?

Production systems misbehave. Processes crash, memory fills up, disk fills up, services fail to start. You need to know how to find out what's happening and intervene. These tools are the foundation of operational work on any Linux system.

## Core Concepts

### Viewing Processes

```bash
ps aux              # all running processes
ps aux | grep nginx # find a specific process
top                 # interactive process viewer
htop                # improved version of top (install separately)
```

`ps aux` columns:
- `PID` — Process ID
- `%CPU` — CPU usage
- `%MEM` — Memory usage
- `VSZ` — Virtual memory
- `RSS` — Resident memory (physical RAM in use)
- `STAT` — Process state (R=running, S=sleeping, Z=zombie)
- `COMMAND` — Command name

### Killing Processes

```bash
kill 1234             # send SIGTERM (graceful shutdown) to PID 1234
kill -9 1234          # send SIGKILL (force kill) — last resort
pkill nginx           # kill by process name
killall nginx         # kill all processes with that name
```

### Background Jobs

```bash
command &             # start in background
jobs                  # list background jobs
fg %1                 # bring job 1 to foreground
bg %1                 # resume job 1 in background
nohup command &       # run even after logout
```

### systemctl — Service Management

```bash
systemctl status nginx          # check service status
systemctl start nginx           # start service
systemctl stop nginx            # stop service
systemctl restart nginx         # restart service
systemctl enable nginx          # start on boot
systemctl disable nginx         # don't start on boot
```

### System Resources

```bash
df -h               # disk usage (human-readable)
du -sh ~/           # size of home directory
free -h             # RAM and swap usage
uptime              # system uptime and load average
```

### Journal Logs

```bash
journalctl -u nginx             # logs for nginx service
journalctl -f                   # follow new log entries
journalctl --since "1 hour ago" # logs from the past hour
```

## Hands-on Task

1. Find the PID of your shell: `echo $$`
2. Run `sleep 300 &` in the background, then find it with `ps aux | grep sleep`
3. Kill the sleep process by PID
4. Check disk usage of your home directory with `du -sh ~`

## Example Commands

```bash
# Find the PID of my shell
echo $$
# Expected output (example):
# 12345

# All processes belonging to my user
ps aux | grep $USER

# Interactive process viewer
top
# Press 'q' to quit, 'k' to kill a process, '1' to see per-CPU stats

# Check disk space
df -h
# Expected output (example):
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1        50G   15G   33G  32% /

# RAM usage
free -h
# Expected output (example):
#               total        used        free      shared  buff/cache   available
# Mem:           15Gi       3.2Gi       9.8Gi       234Mi       2.1Gi        11Gi
```

## Common Mistakes

- **Using `kill -9` immediately** — always try `kill` (SIGTERM) first; `-9` doesn't allow cleanup
- **Not using `nohup`** — background processes die when you log out without it
- **`systemctl` vs service** — `systemctl` is the modern way; `service` is the legacy command on older systems

## Checkpoint

- [ ] I can find a running process by name and by PID
- [ ] I can kill a process gracefully and forcefully
- [ ] I can check disk, memory, and CPU usage
- [ ] I can start, stop, and check the status of a system service

## Definition of Done

You can troubleshoot a misbehaving server: find which process is using too much CPU/memory, kill it, check disk space, and inspect service logs.

## Further Reading

- `man ps`
- `man systemctl`
- `man journalctl`
- `man df`
