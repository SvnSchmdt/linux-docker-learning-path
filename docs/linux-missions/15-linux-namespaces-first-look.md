# Mission 15 – Linux Namespaces: First Look

## Scenario

A colleague says "Docker is just Linux namespaces and cgroups." You nod. You don't actually know what that means. This mission is the bridge: you'll see namespaces in action, understand what isolation Docker actually provides, and confirm that containers are processes — not VMs.

## Goal

Observe Linux namespaces directly, understand what Docker does under the hood, and see the connection between container concepts and kernel primitives.

## What you will practice

- `lsns` — list namespaces
- `/proc/PID/ns/` — namespace file descriptors
- `unshare` — creating isolated environments
- `nsenter` — entering a running namespace
- Namespace types: PID, NET, MNT, UTS, IPC, USER

## Setup

```bash
mkdir -p ~/linux-missions/mission-15
echo "Mission 15 ready — uses /proc and system tools."
```

> [!NOTE]
> Full namespace exploration requires Linux. On macOS, Docker Desktop runs a Linux VM — you can still do Parts 4–6 via `docker exec`. Parts 1–3 require Linux or WSL2.

## Mission

**Part 1 — Your current namespaces**

Every process lives in namespaces. See yours:

```bash
# Your shell's namespaces
ls -la /proc/self/ns/
```

Output (example):

```
lrwxrwxrwx cgroup -> cgroup:[4026531835]
lrwxrwxrwx ipc    -> ipc:[4026531839]
lrwxrwxrwx mnt    -> mnt:[4026531841]
lrwxrwxrwx net    -> net:[4026531992]
lrwxrwxrwx pid    -> pid:[4026531836]
lrwxrwxrwx uts    -> uts:[4026531838]
lrwxrwxrwx user   -> user:[4026531837]
```

The number in brackets is the namespace ID. Two processes with the same ID share that namespace.

Questions:

1. How many namespace types exist?
2. What does the `uts` namespace control?
3. What does the `net` namespace control?

**Part 2 — Namespace types explained**

| Namespace | What it isolates |
|-----------|-----------------|
| `pid` | Process IDs — container PID 1 is host PID 12345 |
| `net` | Network interfaces, routing tables, iptables rules |
| `mnt` | Filesystem mount points — container sees its own filesystem |
| `uts` | Hostname and domain name |
| `ipc` | Inter-process communication (shared memory, message queues) |
| `user` | User IDs — container root can map to non-root on host |
| `cgroup` | cgroup root — resource limits (CPU, memory) |

**Part 3 — Create an isolated hostname namespace (Linux only)**

```bash
# Create a new UTS namespace where you can change the hostname
# without affecting the host
sudo unshare --uts bash << 'INNER'
echo "Inside isolated namespace:"
hostname
hostname mission-15-test
echo "Changed hostname to:"
hostname
echo "Exit namespace:"
INNER

# Back on host — hostname is unchanged
echo "Host hostname still:"
hostname
```

This is exactly what Docker does when you set `--hostname` on a container.

**Part 4 — See Docker containers as processes**

Start a container and observe it from the host:

```bash
docker run -d --name ns-test alpine sleep 300

# Find the container's PID on the host
CONTAINER_PID=$(docker inspect ns-test --format '{{.State.Pid}}')
echo "Container process PID on host: $CONTAINER_PID"

# See the container's namespaces
ls -la /proc/$CONTAINER_PID/ns/
```

Compare the namespace IDs to your shell's namespaces from Part 1:

```bash
ls -la /proc/self/ns/
ls -la /proc/$CONTAINER_PID/ns/
```

Questions:

4. Which namespaces differ between your shell and the container?
5. Which namespaces (if any) are the same?

**Part 5 — Enter the container's namespace**

```bash
# nsenter lets you join a running container's namespace
sudo nsenter -t $CONTAINER_PID --net -- ip addr
# Expected: shows the container's network interfaces (eth0, not your host interfaces)

sudo nsenter -t $CONTAINER_PID --pid --mount -- ps aux
# Expected: shows only the container's processes (just sleep + ps)
```

This is similar to `docker exec`, but at the kernel level.

**Part 6 — cgroups: resource limits**

cgroups control how much CPU and memory a process can use:

```bash
# Run a container with memory limit
docker run -d --name cgroup-test --memory=64m alpine sleep 300

# Find its PID
CGROUP_PID=$(docker inspect cgroup-test --format '{{.State.Pid}}')

# See its memory cgroup (Linux)
cat /proc/$CGROUP_PID/cgroup 2>/dev/null || echo "cgroup info (Docker inspect):"
docker inspect cgroup-test | python3 -m json.tool | grep -A5 '"Memory"'
```

**Part 7 — Confirm: containers are processes**

```bash
# On the host, see the container process
ps aux | grep "sleep 300" | grep -v grep
# Expected: shows PID, user (root or numeric), and "sleep 300"

# The container thinks it's PID 1
docker exec ns-test ps aux
# Expected: sleep is PID 1 inside the container

# Same process, two different PIDs (host vs container namespace)
```

**Bonus:** What is the difference between a container and a VM at the kernel level? What does "container escape" mean?

## Hints

??? hint "Hint 1 – lsns tool"
    ```bash
    # List all namespaces on the system (requires lsns)
    sudo lsns 2>/dev/null || echo "lsns not available"
    # Shows: namespace type, inode, PID, command for each namespace
    ```

??? hint "Hint 2 – What UTS means"
    ```
    UTS = "Unix Time-sharing System" — a legacy name.
    The UTS namespace controls hostname and NIS domain name.
    When you run: docker run --hostname myapp alpine hostname
    Docker creates a new UTS namespace and sets its hostname to "myapp".
    ```

??? hint "Hint 3 – Container escape"
    ```
    A container escape is when a process breaks out of its namespace
    isolation and gains access to host resources.
    Common vectors: privileged containers (--privileged), host path mounts,
    kernel vulnerabilities.
    This is why running containers as root AND as privileged is dangerous:
    a bug in the container engine can give full host access.
    ```

## Validation

```bash
# Container is running
docker ps | grep ns-test

# Container has a different net namespace than host
HOST_NET=$(ls -la /proc/self/ns/net | awk '{print $NF}')
CONT_NET=$(docker inspect ns-test --format '{{.State.Pid}}' | xargs -I{} ls -la /proc/{}/ns/net | awk '{print $NF}')
[ "$HOST_NET" != "$CONT_NET" ] && echo "Different net namespaces: correct" || echo "Same net namespace: unexpected"

# Container PID 1 is a real host PID
docker inspect ns-test --format '{{.State.Pid}}' | xargs -I{} ps -p {} --no-headers
```

## Cleanup

```bash
docker stop ns-test cgroup-test 2>/dev/null || true
docker rm ns-test cgroup-test 2>/dev/null || true
rm -rf ~/linux-missions/mission-15
```

## What you should have learned

- A Docker container is a Linux process with isolated namespaces and cgroup limits
- The 7 namespace types: pid, net, mnt, uts, ipc, user, cgroup
- `unshare` creates new namespace contexts; `nsenter` enters existing ones
- Container PID 1 is a real PID on the host — it just looks like PID 1 inside the container
- "Privileged" containers have fewer namespace restrictions — they're closer to the host, which is dangerous
- This foundation explains every Docker networking, storage, and security concept you'll encounter next

## Next mission

[Mission 16 – Final Linux Bossfight →](16-final-linux-bossfight.md)
