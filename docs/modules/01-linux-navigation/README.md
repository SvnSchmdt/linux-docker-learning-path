# Module 01 – Linux Navigation

## Module Goal

Confidently navigate the Linux filesystem using the command line.

## Why does this matter?

The Linux filesystem is the foundation for everything else. Every config file, log, binary, and user home directory has a specific location in this hierarchy. Knowing where things live — and how to move between them efficiently — is the first real skill of a Linux user.

## Core Concepts

### The Filesystem Hierarchy Standard (FHS)

Linux organizes files into a single tree rooted at `/` (root):

| Directory | Purpose |
|-----------|---------|
| `/` | Root of the entire filesystem |
| `/home` | User home directories (`/home/alice`) |
| `/etc` | System configuration files |
| `/var` | Variable data: logs, databases, caches |
| `/tmp` | Temporary files (cleared on reboot) |
| `/usr` | User-space programs and libraries |
| `/bin`, `/sbin` | Essential system binaries |
| `/opt` | Optional/third-party software |
| `/proc`, `/sys` | Virtual filesystems (kernel data, hardware info) |

### Absolute vs. Relative Paths

- **Absolute path**: starts with `/`, always refers to the same location: `/home/alice/projects`
- **Relative path**: starts from your current directory: `projects/demo` (relative to `/home/alice`)

### Hidden Files

Files starting with `.` are hidden by default:

```bash
ls -a    # shows hidden files
ls -la   # long format + hidden
```

## Hands-on Task

1. Find where you are: `pwd`
2. List the root directory: `ls /`
3. Navigate to `/etc` and back home: `cd /etc && cd ~`
4. Find all hidden files in your home directory: `ls -la ~`
5. Use `tree` to visualize a directory (install with `brew install tree` on macOS)

## Example Commands

```bash
# Where am I?
pwd
# Expected output:
# /home/alice

# List current directory (long format, human-readable sizes, hidden files)
ls -lah

# Navigate to home directory (three equivalent ways)
cd ~
cd $HOME
cd

# Navigate up one level
cd ..

# Navigate to previous directory
cd -

# Show directory tree (3 levels deep)
tree -L 3 /etc

# Find hidden files in home
ls -la ~ | grep '^\.'
```

## Common Mistakes

- **Confusing `/` (root directory) with the root user's home** — the root user's home is `/root`, not `/`
- **Forgetting that paths are case-sensitive** — `/etc/Hosts` and `/etc/hosts` are different files
- **Using `cd` without a path** — this takes you home, not to the previous directory (`cd -` does that)

## Checkpoint

- [ ] I can navigate to any absolute path without getting lost
- [ ] I understand the difference between absolute and relative paths
- [ ] I know what's in `/etc`, `/var`, `/tmp`, and `/home`
- [ ] I can find hidden files with `ls -a`

## Definition of Done

You can navigate the Linux filesystem without hesitation, explain where common directories are located, and find files using both absolute and relative paths.

## Further Reading

- `man hier` — description of the file system hierarchy
- `man ls` — all ls flags
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
