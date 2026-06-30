# Module 04 – Users & sudo

## Module Goal

Understand Linux user management and use `sudo` safely and correctly.

## Why does this matter?

Linux is a multi-user system. Knowing who you are, what permissions you have, and when/how to elevate privileges is fundamental to working safely on any Linux system. Running everything as root is a common beginner mistake with serious security consequences.

## Core Concepts

### Who am I?

```bash
whoami          # current username
id              # user ID, group ID, and group memberships
id alice        # info about another user
```

### The /etc/passwd and /etc/group Files

```bash
cat /etc/passwd   # user accounts (username:x:UID:GID:comment:home:shell)
cat /etc/group    # groups (groupname:x:GID:members)
```

> [!NOTE]
> On modern systems, passwords are stored in `/etc/shadow`, not `/etc/passwd`. The `x` in `/etc/passwd` is a placeholder.

### sudo — Superuser Do

`sudo` lets authorized users run commands as root (or another user):

```bash
sudo apt update             # run as root
sudo -u postgres psql       # run as the postgres user
sudo -i                     # open a root shell (use sparingly)
```

### su — Switch User

```bash
su alice            # switch to user alice (needs alice's password)
su -                # switch to root with root's environment
```

### User Management

```bash
sudo useradd -m -s /bin/bash newuser    # create user with home dir and bash
sudo passwd newuser                     # set password
sudo usermod -aG docker alice           # add alice to the docker group
sudo userdel -r olduser                 # delete user and home directory
```

### Principle of Least Privilege

Only give users the permissions they need — nothing more. Key practices:

1. Don't use the root account for daily work
2. Use `sudo` only for specific commands that need it
3. Don't add users to `sudo` group unless necessary
4. Prefer dedicated service accounts over running as root

## Hands-on Task

1. Check your user ID and group memberships with `id`
2. Look up your entry in `/etc/passwd`
3. Run `sudo whoami` and observe the output
4. Check what sudo permissions you have: `sudo -l`

## Example Commands

```bash
# Who am I?
whoami
# Expected output:
# alice

# Full identity info
id
# Expected output:
# uid=1000(alice) gid=1000(alice) groups=1000(alice),4(adm),27(sudo),999(docker)

# View current user's entry in passwd
grep "^$(whoami):" /etc/passwd

# Run a single command as root
sudo cat /etc/shadow

# Update package lists (requires root on Debian/Ubuntu)
sudo apt update

# Add user to docker group (required to run docker without sudo)
sudo usermod -aG docker $USER
# Note: requires logout/login to take effect

# Check sudo permissions
sudo -l
```

## Common Mistakes

- **`sudo su -` instead of `sudo -i`** — both open a root shell, but `sudo -i` is cleaner
- **Using root for everyday tasks** — creates risk; use a normal user account
- **`sudo` password is YOUR password** — not the root password (unless root has a separate password set)
- **Forgetting to log out after adding yourself to a group** — group changes require a new login session

> [!CAUTION]
> Running `sudo rm -rf /` or similar destructive commands as root can permanently destroy the system. Always double-check what you're deleting.

## Checkpoint

- [ ] I know my UID, GID, and group memberships
- [ ] I can use `sudo` for individual commands
- [ ] I understand the difference between `sudo` and `su`
- [ ] I know why running as root for daily work is a bad practice

## Definition of Done

You can explain the principle of least privilege, use `sudo` correctly, and manage basic user accounts.

## Further Reading

- `man sudo`
- `man useradd`
- `man passwd`
- `man visudo` — safely edit the sudoers file
