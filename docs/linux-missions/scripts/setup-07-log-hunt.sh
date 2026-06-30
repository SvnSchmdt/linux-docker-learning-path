#!/usr/bin/env bash
# Setup script for Mission 07 – Log Hunt
# Generates a realistic multi-day application log with errors to find.
# Safe: only writes to ~/linux-missions/mission-07/

set -e
TARGET=~/linux-missions/mission-07
rm -rf "$TARGET"
mkdir -p "$TARGET"

cat > "$TARGET/app.log" << 'EOF'
2026-06-28 08:00:01 INFO  [startup] Application starting, version=3.2.1
2026-06-28 08:00:03 INFO  [db] Connected to postgres://db:5432/appdb
2026-06-28 08:00:04 INFO  [cache] Connected to redis://cache:6379
2026-06-28 08:01:12 INFO  [http] GET /api/users 200 12ms
2026-06-28 08:01:45 INFO  [http] GET /api/products 200 8ms
2026-06-28 08:03:01 WARN  [db] Query took 2341ms: SELECT * FROM orders
2026-06-28 08:05:22 INFO  [http] POST /api/orders 201 45ms
2026-06-28 09:00:00 INFO  [cron] Running scheduled cleanup job
2026-06-28 09:00:01 INFO  [cron] Deleted 142 expired sessions
2026-06-28 10:11:34 ERROR [db] Connection pool exhausted: all 10 connections in use
2026-06-28 10:11:34 ERROR [http] POST /api/orders 503 timeout
2026-06-28 10:11:35 ERROR [db] Connection pool exhausted: all 10 connections in use
2026-06-28 10:11:36 ERROR [http] GET /api/users 503 timeout
2026-06-28 10:11:40 INFO  [db] Connection released, pool available again
2026-06-28 10:12:01 INFO  [http] GET /api/users 200 9ms
2026-06-28 14:22:09 WARN  [memory] Heap usage at 78% (1.56 GB / 2 GB)
2026-06-28 14:22:10 INFO  [gc] Garbage collection triggered
2026-06-28 14:22:13 INFO  [gc] Freed 340 MB
2026-06-29 01:00:00 INFO  [cron] Running nightly report job
2026-06-29 01:00:45 INFO  [cron] Report generated: /var/reports/daily-2026-06-28.pdf
2026-06-29 06:30:00 INFO  [startup] Application restarted (scheduled maintenance)
2026-06-29 06:30:02 INFO  [db] Connected to postgres://db:5432/appdb
2026-06-29 06:30:03 INFO  [cache] Connected to redis://cache:6379
2026-06-29 08:44:12 INFO  [http] GET /api/users 200 11ms
2026-06-29 11:01:55 ERROR [auth] Invalid token for user_id=1042: token expired
2026-06-29 11:02:01 INFO  [auth] User 1042 re-authenticated successfully
2026-06-29 13:15:22 ERROR [storage] Failed to write /data/uploads/file_9981.bin: no space left on device
2026-06-29 13:15:22 CRITICAL [storage] Upload directory full! Capacity: 100%
2026-06-29 13:15:23 ERROR [http] POST /api/upload 500 disk full
2026-06-29 13:15:24 ERROR [http] POST /api/upload 500 disk full
2026-06-29 13:15:25 ERROR [http] POST /api/upload 500 disk full
2026-06-29 13:16:01 WARN  [ops] Automated cleanup triggered for /data/tmp
2026-06-29 13:16:05 INFO  [ops] Freed 4.2 GB in /data/tmp
2026-06-29 13:16:06 INFO  [storage] Upload directory available again (62% used)
2026-06-29 13:16:07 INFO  [http] POST /api/upload 200 234ms
2026-06-30 08:00:00 INFO  [startup] Application starting, version=3.2.1
2026-06-30 08:00:02 INFO  [db] Connected to postgres://db:5432/appdb
2026-06-30 08:00:03 INFO  [cache] Connected to redis://cache:6379
2026-06-30 10:55:44 INFO  [http] GET /api/health 200 2ms
EOF

echo ""
echo "Mission 07 setup complete."
echo "Lab directory: $TARGET"
echo "Start with: ls -lh $TARGET/app.log"
