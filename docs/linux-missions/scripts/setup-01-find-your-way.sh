#!/usr/bin/env bash
# Setup script for Mission 01 – Find Your Way
# Creates a directory tree with hidden clues for the learner to find.
# Safe: only writes to ~/linux-missions/mission-01/

set -e
TARGET=~/linux-missions/mission-01
rm -rf "$TARGET"
mkdir -p "$TARGET"/{logs,config,data/raw,data/processed,src,.hidden}

# Plant files with content
cat > "$TARGET/config/app.conf" << 'EOF'
# Application configuration
port=8080
log_level=info
secret_word=archipelago
max_connections=100
EOF

cat > "$TARGET/logs/app.log" << 'EOF'
2026-06-30 10:00:01 INFO  Server started on port 8080
2026-06-30 10:00:05 INFO  Connection from 192.168.1.10
2026-06-30 10:01:02 ERROR Timeout reading request body
2026-06-30 10:01:15 INFO  Connection from 10.0.0.5
2026-06-30 10:02:44 WARN  Memory usage above 80%
2026-06-30 10:03:01 ERROR Database connection refused: db:5432
2026-06-30 10:03:45 INFO  Reconnected to database
EOF

cat > "$TARGET/src/server.py" << 'EOF'
# Simple server stub
# Version: 2.1.4
# Author: ops-team
HOST = "0.0.0.0"
PORT = 8080
EOF

cat > "$TARGET/data/raw/users.csv" << 'EOF'
id,name,role
1,alice,admin
2,bob,developer
3,carol,viewer
4,dave,developer
EOF

echo "hint: check hidden directories with ls -a" > "$TARGET/.hidden/clue.txt"
echo "the-answer-is-42" > "$TARGET/data/processed/result.txt"
echo "admin" > "$TARGET/data/raw/secret_role.txt"

echo ""
echo "Mission 01 setup complete."
echo "Lab directory: $TARGET"
echo "Start with: ls $TARGET"
