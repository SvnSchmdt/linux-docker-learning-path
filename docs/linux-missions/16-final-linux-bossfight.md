# Mission 16 – Final Linux Bossfight

## Scenario

You receive a ticket:

> **INCIDENT P1 — Production web app unreachable**
>
> The web app at `localhost:8080` was working yesterday. Since the last deploy it isn't responding.
> The on-call engineer tried restarting it and got an error. The logs are stale.
> You've been handed the directory. Figure out what's broken and fix it.
>
> — Ops Team

There is no documentation. There is no one to ask. There are at least three bugs.

## Goal

Find all bugs in a broken application, fix them in the correct order, and get the web app running and responding to HTTP requests. Then write a root cause summary.

## What you will practice

Everything from Missions 01–15:

- File navigation and inspection
- Permission diagnosis
- Config file parsing
- Process management
- HTTP testing
- Log investigation
- Debugging by reading error messages

## Setup

```bash
bash ~/path/to/docs/linux-missions/scripts/setup-16-bossfight.sh
```

When done:

```
Bossfight setup complete.
Lab directory: ~/linux-missions/mission-16

INCIDENT REPORT:
  The web app at localhost:8080 stopped responding.
  On-call engineer says it was working yesterday.
  Go investigate.

Start with: ls ~/linux-missions/mission-16
```

## Mission

You have the directory. The rest is up to you.

**Rules:**

- Do not look at the setup script
- Do not read ahead in this document
- Fix each bug as you find it — do not collect all bugs first
- Write down every command you run and what you observed
- Time yourself: Gold requires under 20 minutes

**Your only starting hint:**

```bash
ls ~/linux-missions/mission-16
```

---

*Start the timer. Find the bugs. Fix them. Run the app.*

---

## Hints

Use these only after attempting each fix independently for at least 5 minutes.

??? hint "Bug Clue 1 – The first error"
    ```bash
    bash ~/linux-missions/mission-16/start.sh
    # What error do you see? Read it carefully.
    # The first error message tells you exactly what is wrong.
    ```

??? hint "Bug Clue 2 – A permissions issue"
    ```bash
    ls -la ~/linux-missions/mission-16/
    # Look at start.sh. What are its permissions?
    # Can it be executed?
    ```

??? hint "Bug Clue 3 – A config issue"
    ```bash
    cat ~/linux-missions/mission-16/config/app.conf
    # Read every value carefully.
    # Look for a value that appears correct but isn't.
    # Typos are hard to see when you're looking for code bugs.
    ```

??? hint "Bug Clue 4 – Testing after fixes"
    ```bash
    # After fixing all bugs, start the server
    bash ~/linux-missions/mission-16/start.sh &
    sleep 1
    curl http://localhost:8080/health
    curl http://localhost:8080/
    ```

## Validation

After fixing all bugs, the app should run and respond:

```bash
# Kill any running instance first
pkill -f "server.py" 2>/dev/null; sleep 1

# Start the fixed app
bash ~/linux-missions/mission-16/start.sh &
sleep 2

# Test both endpoints
curl -s http://localhost:8080/
# Expected: "Web app is running!"

curl -s http://localhost:8080/health
# Expected: {"status": "ok", "port": 8080}

# Clean up
pkill -f "server.py" 2>/dev/null || true
```

If both return expected responses: you've beaten the bossfight.

## Root Cause Summary (required for Gold)

After fixing the app, write a brief root cause summary. A real engineer would file this as a post-mortem. Format:

```markdown
## Incident: Web App Unreachable

**Date:** 2026-06-30
**Duration:** [time to resolve]
**Impact:** Web app completely unreachable on port 8080

### Root Cause

[Describe each bug found, in order of discovery]

### Timeline

| Time | Action |
|------|--------|
| T+0  | Started investigation |
| T+X  | Found bug 1 |
| T+X  | Fixed bug 1 |
| T+X  | Found bug 2 |
| T+X  | Fixed bug 2 |
| T+X  | App running |

### Fix

[What was changed and why]

### Prevention

[What would have caught this before deployment?]
```

Save this file:

```bash
nano ~/linux-missions/mission-16/postmortem.md
```

## Scoring

| Score | Criteria |
|-------|----------|
| **Bronze** | App is running and responding. Hints were used. |
| **Silver** | App is running. No hints used. |
| **Gold** | App is running. No hints. Post-mortem written. Completed in under 20 minutes. |

## Cleanup

```bash
pkill -f "server.py" 2>/dev/null || true
rm -rf ~/linux-missions/mission-16
```

## What you should have learned

If you found the bugs without hints, you have internalized the most important Linux debugging workflow:

1. **Start with what's visible** — `ls`, read the files
2. **Try to run it** — read the exact error message
3. **Fix the first error** — don't guess ahead
4. **Test after each fix** — confirm it actually worked
5. **Read configs character by character** — typos are the most common bug

These five steps will solve 80% of Linux production incidents.

**You are now ready to work with Docker in a production context.**

---

*Congratulations. You've completed the Linux Missions track.*

*Continue to the [Docker modules →](../modules/09-container-basics/README.md)*
