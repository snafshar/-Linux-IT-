# Disk Audit

A small, read-only Bash utility for checking filesystem space and identifying large files in a chosen directory.

## Run

```bash
chmod +x disk_audit.sh
./disk_audit.sh /var/log
```

Use a directory you are allowed to inspect. The script does not delete, move, or modify files.

## What it reports

- Filesystem usage from `df`
- Directory size from `du`
- The largest files found beneath the requested path
- A clear error if the path is missing or not a directory

## Learning goals

Practice argument validation, quoting paths safely, pipelines, sorting, and handling command failures.
