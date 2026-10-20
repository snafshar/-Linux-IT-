# Disk Space Pressure Runbook

1. Start with `df -h` to identify the full filesystem.
2. Use `df -i` to check inode exhaustion separately.
3. Inspect top-level directory sizes with `du -xhd1 PATH 2>/dev/null | sort -h` on systems supporting those flags.
4. Check for deleted-but-open files with `lsof +L1` if available.
5. Do not delete unknown files, database files, or logs currently being written.
6. Confirm backups and retention policies before cleanup.
7. Recheck free space and document the cause.

Prefer identifying a growing workload over repeatedly deleting files. Commands above are diagnostic; cleanup requires an explicit change plan.
