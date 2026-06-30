# Mission 03 – Process Detective

## Scenario

Something is consuming CPU on this machine. You don't know what it is. The monitoring dashboard is down. You only have a terminal.

## Goal

Find, inspect, and stop background processes using only command-line tools.

## What you will practice

- `ps aux` — list all processes
- `top` / `htop` — real-time process view
- `kill` and `pkill` — stopping processes
- Exit codes with `$?`
- PID inspection

## Setup

Run these commands directly to create some background processes:

```bash
mkdir -p ~/linux-missions/mission-03

# Start three sleep processes simulating background workers
sleep 9999 &
sleep 9998 &
sleep 9997 &

# Write their PIDs so you can find them later
jobs -l
echo "Three background processes started."
```

## Mission

**Part 1 — Find the intruders**

List all running processes and filter for your own background jobs:

```bash
ps aux | grep sleep
```

Expected output (example — PIDs will differ):

```
alice    12345  0.0  0.0   8080   500 pts/0  S  10:00   0:00 sleep 9999
alice    12346  0.0  0.0   8080   500 pts/0  S  10:00   0:00 sleep 9998
alice    12347  0.0  0.0   8080   500 pts/0  S  10:00   0:00 sleep 9997
```

Answer these questions:

1. What does the `S` in the STAT column mean?
2. What is the PID of the `sleep 9998` process?
3. What does `%CPU` show for an idle `sleep` process?

**Part 2 — Inspect with top**

```bash
top
```

- Press `1` to see per-CPU breakdown
- Press `M` to sort by memory usage
- Press `k`, enter a PID, and press Enter to kill a process from within top
- Press `q` to quit

**Part 3 — Kill processes**

Kill the `sleep 9997` process by PID:

```bash
kill <PID of sleep 9997>
```

Verify it's gone:

```bash
ps aux | grep "sleep 9997"
# Should return nothing (except the grep itself)
```

Kill the remaining two processes by name:

```bash
pkill -f "sleep 999"
```

Verify all are gone:

```bash
jobs
# Expected: (empty — no background jobs)
```

**Part 4 — Exit codes**

```bash
ls /nonexistent-path
echo "Exit code: $?"
# Expected: Exit code: 1 (or 2 on some systems)

ls /tmp
echo "Exit code: $?"
# Expected: Exit code: 0
```

**Bonus:** What happens when you `kill -9` vs `kill` (without a signal)? What signal does plain `kill` send?

## Hints

??? hint "Hint 1 – Finding specific sleep processes"
    ```bash
    ps aux | grep "sleep 999" | grep -v grep
    # -v grep removes the grep process itself from results
    ```

??? hint "Hint 2 – Killing by name pattern"
    ```bash
    pkill -f "sleep 999"
    # -f matches against the full command line, not just process name
    ```

??? hint "Hint 3 – What STAT codes mean"
    ```
    R = running or runnable
    S = sleeping (interruptible)
    D = uninterruptible sleep (usually I/O)
    Z = zombie (process finished, parent hasn't reaped it)
    T = stopped
    ```

## Validation

```bash
# No sleep 999x processes should remain
ps aux | grep "sleep 999" | grep -v grep
# Expected: (empty)

# Exit code of a successful command
true; echo $?
# Expected: 0

# Exit code of a failed command
false; echo $?
# Expected: 1
```

## Cleanup

```bash
pkill -f "sleep 999" 2>/dev/null || true
rm -rf ~/linux-missions/mission-03
```

## What you should have learned

- `ps aux` gives you a full snapshot of running processes
- `kill PID` sends SIGTERM (graceful stop); `kill -9 PID` sends SIGKILL (immediate)
- `pkill -f` is useful when you know part of the command line
- `$?` holds the exit code of the last command — 0 means success
- A zombie process (`Z`) means the parent didn't call `wait()` — not your fault, but worth knowing

## Next mission

[Mission 04 – Port in Use →](04-port-in-use.md)
