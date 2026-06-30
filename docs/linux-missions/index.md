# Linux Missions

Theory tells you what commands do. Missions make you use them when something is broken.

Each mission drops you into a scenario — a misbehaving server, a script that won't run, a log file full of noise. Your job is to investigate, figure out what's wrong, and fix it. No hand-holding. Hints are available but kept separate.

> [!NOTE]
> Missions are intentionally practical. They are designed to build command-line confidence before Docker and Kubernetes — because containers run on Linux, and broken containers are just broken Linux with extra packaging.

## Before You Start

- You need a Linux or macOS terminal (WSL2 on Windows works)
- Each mission is self-contained — do them in order or jump around
- Run the `## Setup` script first, then attempt the `## Mission` section
- Check `## Hints` only after you've genuinely tried

## Mission Map

| # | Mission | Skills |
|---|---------|--------|
| [01](01-find-your-way.md) | Find Your Way | `ls`, `find`, `grep`, `cat` |
| [02](02-permission-denied.md) | Permission Denied | `chmod`, `ls -l`, permissions |
| [03](03-process-detective.md) | Process Detective | `ps`, `kill`, exit codes |
| [04](04-port-in-use.md) | Port in Use | `ss`, port conflicts |
| [05](05-dns-is-broken.md) | DNS is Broken | `dig`, `ping`, `/etc/resolv.conf` |
| [06](06-service-wont-start.md) | Service Won't Start | `systemctl`, `journalctl` |
| [07](07-log-hunt.md) | Log Hunt | `grep`, `tail`, log analysis |
| [08](08-disk-full.md) | Disk Full | `df`, `du`, disk pressure |
| [09](09-ssh-key-trouble.md) | SSH Key Trouble | key permissions, SSH concepts |
| [10](10-cron-did-not-run.md) | Cron Did Not Run | cron, PATH, environment |
| [11](11-poor-mans-monitoring.md) | Poor Man's Monitoring | shell scripts, observability |
| [12](12-backup-and-restore.md) | Backup and Restore | `tar`, `diff`, checksums |
| [13](13-network-sleuth.md) | Network Sleuth | `ip`, `ss`, `curl`, routing |
| [14](14-build-a-mini-webserver.md) | Build a Mini Webserver | Python HTTP server, ports |
| [15](15-linux-namespaces-first-look.md) | Linux Namespaces | `/proc`, `unshare`, containers |
| [16](16-final-linux-bossfight.md) | Final Linux Bossfight | Everything — incident response |

## Scoring

Every mission has a self-assessment at the end:

- **Bronze** — solved with hints
- **Silver** — solved without hints
- **Gold** — solved, wrote a clean root-cause summary

Nobody is tracking you. Be honest with yourself.

## Recommended Order in the Learning Path

```
Linux Modules (00–08)
      ↓
Linux Missions (01–16)   ← you are here
      ↓
Linux Checkpoint
      ↓
Docker Modules (09–15)
      ↓
Docker Labs
      ↓
Bridge to Kubernetes
```
