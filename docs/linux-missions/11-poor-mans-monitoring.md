# Mission 11 – Poor Man's Monitoring

## Scenario

You have a server. It has no monitoring. You have no budget for a monitoring tool. You have bash.

Your job is to build a basic monitoring script that checks CPU, memory, disk, and a running process — and alerts when something looks wrong.

## Goal

Write a shell script that performs basic system health checks and produces a structured report. No third-party tools.

## What you will practice

- `uptime` — load average
- `free -h` — memory usage
- `df -h` — disk usage
- `ps aux` — process checks
- Shell scripting: conditionals, arithmetic, string formatting
- Redirect and pipes for output formatting

## Setup

```bash
mkdir -p ~/linux-missions/mission-11
echo "Mission 11 ready — no pre-generated files needed."
```

## Mission

Build this incrementally. Each part adds one check to the monitoring script.

**Part 1 — Collect raw data**

Run these commands and understand what each returns:

```bash
# Load average (1, 5, 15 minute)
uptime

# Memory
free -h

# Disk (root filesystem only)
df -h /

# Is Python running?
pgrep -x python3 && echo "python3 is running" || echo "python3 not found"
```

**Part 2 — Start the monitoring script**

```bash
cat > ~/linux-missions/mission-11/check.sh << 'SCRIPT'
#!/usr/bin/env bash
# System health monitor

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)
OK=0
WARN=0
CRIT=0

echo "========================================="
echo "  Health Report: $HOSTNAME"
echo "  $TIMESTAMP"
echo "========================================="

# --- CPU Load ---
LOAD1=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
CPU_COUNT=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
# Load per CPU (bash can't do floats; multiply by 100 first)
LOAD_INT=$(echo "$LOAD1 * 100 / $CPU_COUNT" | bc 2>/dev/null || echo "0")
if [ "$LOAD_INT" -gt 200 ]; then
  echo "[CRIT] CPU load: $LOAD1 (${LOAD_INT}% per core)"
  CRIT=$((CRIT + 1))
elif [ "$LOAD_INT" -gt 100 ]; then
  echo "[WARN] CPU load: $LOAD1 (${LOAD_INT}% per core)"
  WARN=$((WARN + 1))
else
  echo "[ OK ] CPU load: $LOAD1 (${LOAD_INT}% per core)"
  OK=$((OK + 1))
fi

# --- Memory ---
MEM_USED=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')
if [ "$MEM_USED" -gt 90 ]; then
  echo "[CRIT] Memory: ${MEM_USED}% used"
  CRIT=$((CRIT + 1))
elif [ "$MEM_USED" -gt 75 ]; then
  echo "[WARN] Memory: ${MEM_USED}% used"
  WARN=$((WARN + 1))
else
  echo "[ OK ] Memory: ${MEM_USED}% used"
  OK=$((OK + 1))
fi

# --- Disk ---
DISK_USED=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USED" -gt 90 ]; then
  echo "[CRIT] Disk /: ${DISK_USED}% used"
  CRIT=$((CRIT + 1))
elif [ "$DISK_USED" -gt 75 ]; then
  echo "[WARN] Disk /: ${DISK_USED}% used"
  WARN=$((WARN + 1))
else
  echo "[ OK ] Disk /: ${DISK_USED}% used"
  OK=$((OK + 1))
fi

# --- Process check ---
WATCH_PROCESS="${WATCH_PROCESS:-sshd}"
if pgrep -x "$WATCH_PROCESS" > /dev/null 2>&1; then
  echo "[ OK ] Process: $WATCH_PROCESS is running"
  OK=$((OK + 1))
else
  echo "[CRIT] Process: $WATCH_PROCESS is NOT running"
  CRIT=$((CRIT + 1))
fi

# --- Summary ---
echo "-----------------------------------------"
echo "  Summary: OK=$OK WARN=$WARN CRIT=$CRIT"
echo "========================================="

# Exit code reflects worst state
[ "$CRIT" -gt 0 ] && exit 2
[ "$WARN" -gt 0 ] && exit 1
exit 0
SCRIPT

chmod +x ~/linux-missions/mission-11/check.sh
echo "Script created."
```

**Part 3 — Run the monitoring script**

```bash
bash ~/linux-missions/mission-11/check.sh
echo "Exit code: $?"
```

Expected output structure:

```
=========================================
  Health Report: myserver
  2026-06-30 14:22:01
=========================================
[ OK ] CPU load: 0.12 (12% per core)
[ OK ] Memory: 43% used
[ OK ] Disk /: 61% used
[ OK ] Process: sshd is running
-----------------------------------------
  Summary: OK=4 WARN=0 CRIT=0
=========================================
Exit code: 0
```

**Part 4 — Test with a custom process**

```bash
# Check for a process that doesn't exist
WATCH_PROCESS=doesnotexist bash ~/linux-missions/mission-11/check.sh
echo "Exit code: $?"
# Expected: CRIT for the process, exit code 2
```

**Part 5 — Add to cron (optional)**

```bash
# Run every 5 minutes, log output
# 0/5 * * * * bash ~/linux-missions/mission-11/check.sh >> ~/linux-missions/mission-11/health.log 2>&1
```

**Bonus:** Extend the script to also check whether a URL returns HTTP 200 using `curl -sf`. Alert `[CRIT]` if it doesn't.

## Hints

??? hint "Hint 1 – Getting memory usage as a percentage"
    ```bash
    free | awk '/^Mem:/ {printf "%.0f\n", $3/$2 * 100}'
    # $3 = used, $2 = total
    ```

??? hint "Hint 2 – Getting disk usage as integer"
    ```bash
    df / | awk 'NR==2 {print $5}' | tr -d '%'
    # NR==2 = second line (skip header)
    # tr -d '%' = remove the percent sign
    ```

??? hint "Hint 3 – HTTP check bonus"
    ```bash
    URL="${CHECK_URL:-http://localhost:8080/health}"
    if curl -sf --max-time 5 "$URL" > /dev/null; then
      echo "[ OK ] HTTP: $URL responds"
    else
      echo "[CRIT] HTTP: $URL unreachable"
    fi
    ```

## Validation

```bash
# Script is executable
[ -x ~/linux-missions/mission-11/check.sh ] && echo "Executable: yes"

# Script produces expected sections
bash ~/linux-missions/mission-11/check.sh | grep -E "OK|WARN|CRIT" | wc -l
# Expected: at least 4 check lines

# Exit code for process not found
WATCH_PROCESS=thisdoesnotexist bash ~/linux-missions/mission-11/check.sh
echo "Exit code was: $?"
# Expected: 2 (CRIT)
```

## Cleanup

```bash
rm -rf ~/linux-missions/mission-11
```

## What you should have learned

- `uptime`, `free`, `df`, and `pgrep` are the four pillars of basic Linux monitoring
- Shell scripts can make decisions and set exit codes — 0=ok, 1=warn, 2=critical
- Environment variables (`WATCH_PROCESS=`) make scripts configurable without editing
- This pattern is used by Nagios plugins, Zabbix checks, and Kubernetes liveness probes
- In production, this logic runs inside health check endpoints — the principle is identical

## Next mission

[Mission 12 – Backup and Restore →](12-backup-and-restore.md)
