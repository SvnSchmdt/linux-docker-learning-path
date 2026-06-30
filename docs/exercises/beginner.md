# Beginner Exercises

Complete these after Modules 00–04. Try to solve each one without looking at the module notes.

## Linux Navigation

**Exercise 1:** Find all directories in `/etc` that start with the letter `s`. How many are there?

**Exercise 2:** Navigate to `/var/log` and find the three largest files there.

**Exercise 3:** Create the following directory structure in one command:
```
~/practice/
├── web/
├── api/
└── data/
    ├── raw/
    └── processed/
```

## Files & Permissions

**Exercise 4:** Create a file `~/practice/web/index.html` with the content `<h1>Hello</h1>`. Set its permissions to `644`.

**Exercise 5:** Create a script `~/practice/api/start.sh` with content `echo "Starting API"`. Make it executable. Verify with `ls -la`.

**Exercise 6:** Create a symlink `~/practice/current` pointing to `~/practice/web`. Then run `ls -la ~/practice/current/`.

## Text Processing

**Exercise 7:** Count how many files are in `/etc` (not directories, just files). Use `find` and `wc`.

**Exercise 8:** Find all lines in `/etc/hosts` that do NOT start with `#`. (Hint: `grep -v`)

**Exercise 9:** Create a file `~/practice/data/raw/numbers.txt` containing the numbers 5, 3, 8, 1, 9, 2, 7, 4, 6 (one per line). Sort them numerically and save to `~/practice/data/processed/sorted.txt`.

## Users & sudo

**Exercise 10:** Display your username, UID, and all groups you belong to in one command.

**Exercise 11:** Run `sudo whoami` and explain what the output means.

**Exercise 12:** Find your own entry in `/etc/passwd` and identify: your home directory, your default shell.

---

**Cleanup:**
```bash
rm -rf ~/practice
```
