# Mission 06 – Service Won't Start

## Scenario

After a server reboot, the application isn't running. The team is waiting. You log in and check — no process, no error message visible. You need to figure out what happened and get the service back up.

## Goal

Use `systemd` and `journald` to diagnose why a service failed to start, read structured logs, and restart it correctly.

## What you will practice

- `systemctl status` — check service state
- `journalctl -u` — read service logs
- `systemctl start`, `restart`, `enable`
- Understanding systemd unit files
- Reading error messages from service logs

## Setup

This mission uses systemd, which requires Linux with systemd (not available on macOS). If you're on macOS, use a Linux VM, Docker container, or WSL2.

```bash
# Confirm systemd is available
systemctl --version 2>/dev/null || echo "systemd not available on this system"
```

If systemd is not available, run this simulation instead and answer questions based on the simulated output:

```bash
mkdir -p ~/linux-missions/mission-06

# Simulate a failed service log entry
cat > ~/linux-missions/mission-06/fake-service.log << 'EOF'
Jun 29 10:00:01 server myapp[1234]: Reading config from /etc/myapp/app.conf
Jun 29 10:00:01 server myapp[1234]: FATAL: Config file not found: /etc/myapp/app.conf
Jun 29 10:00:01 server systemd[1]: myapp.service: Main process exited, code=exited, status=1/FAILURE
Jun 29 10:00:01 server systemd[1]: myapp.service: Failed with result 'exit-code'.
Jun 29 10:00:01 server systemd[1]: Failed to start My Application Service.
EOF
echo "Simulation ready at ~/linux-missions/mission-06/fake-service.log"
```

## Mission

**Part 1 — Check service status**

On a Linux system with systemd:

```bash
# Check a well-known service
systemctl status ssh 2>/dev/null || systemctl status sshd 2>/dev/null
```

Read the output fields:

- `Active: active (running)` or `failed` or `inactive`
- `Main PID` — the process ID if running
- `Status:` — custom status message from the app
- The last few log lines shown below the header

**Part 2 — Simulate a failed service**

Without root access you can't create real systemd services, but you can understand the diagnostics:

```bash
cat ~/linux-missions/mission-06/fake-service.log
```

Based on this log, answer:

1. What was the name of the failed service?
2. What was the exact error message that caused the failure?
3. What file was missing?
4. What exit code did the process return?

**Part 3 — Read real service logs with journalctl**

On Linux:

```bash
# Last 50 lines from sshd
journalctl -u ssh --no-pager -n 50 2>/dev/null || \
journalctl -u sshd --no-pager -n 50 2>/dev/null

# Follow logs in real-time (like tail -f)
journalctl -u ssh -f 2>/dev/null &
sleep 3
kill %1 2>/dev/null
```

**Part 4 — The fix pattern**

For the simulated scenario: the config file is missing. Here's how you'd fix it:

```bash
# Step 1: Confirm the error
# (read the log — missing /etc/myapp/app.conf)

# Step 2: Find where the config should come from
# grep the service unit file for config path:
# systemctl cat myapp.service

# Step 3: Create the config
sudo mkdir -p /etc/myapp
sudo tee /etc/myapp/app.conf << 'EOF'
port=8080
log_level=info
EOF

# Step 4: Restart the service
sudo systemctl restart myapp

# Step 5: Verify
systemctl status myapp
```

**Part 5 — Understanding enable vs start**

```bash
systemctl is-enabled ssh 2>/dev/null || echo "Not available"
```

- `systemctl start` — start now
- `systemctl enable` — start on boot
- `systemctl enable --now` — both at once

**Bonus:** What is the difference between `systemctl restart` and `systemctl reload`?

## Hints

??? hint "Hint 1 – Narrowing down the failure"
    ```bash
    # Most useful journalctl flags
    journalctl -u myapp.service --no-pager -n 100
    # -u = unit name
    # --no-pager = don't page through (just print)
    # -n 100 = last 100 lines
    ```

??? hint "Hint 2 – When the error is not obvious"
    ```bash
    # Show all log levels including debug
    journalctl -u myapp.service -p debug --no-pager -n 200

    # Show logs since last boot
    journalctl -u myapp.service -b --no-pager
    ```

??? hint "Hint 3 – Checking the unit file"
    ```bash
    systemctl cat myapp.service
    # Shows ExecStart=, WorkingDirectory=, EnvironmentFile=, etc.
    # Often reveals why the service fails
    ```

## Validation

```bash
# Verify log reading works
cat ~/linux-missions/mission-06/fake-service.log | grep "FATAL"
# Expected: FATAL: Config file not found: /etc/myapp/app.conf

cat ~/linux-missions/mission-06/fake-service.log | grep "exit-code"
# Expected: line with "exit-code" and "FAILURE"
```

## Cleanup

```bash
rm -rf ~/linux-missions/mission-06
```

## What you should have learned

- `systemctl status <service>` is always your first diagnostic step
- `journalctl -u <service> -n 100` shows you the logs that explain the failure
- Most service failures have simple causes: missing config file, wrong permissions, bad port, dependency not running
- `enable` ≠ `start` — services that are started but not enabled disappear after reboot
- In Docker: containers don't use systemd — they run one process directly, and that process's stdout/stderr is the "journal"

## Next mission

[Mission 07 – Log Hunt →](07-log-hunt.md)
