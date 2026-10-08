# Linux Backup Manager

A defensive Bash backup utility for creating timestamped compressed archives and managing retention.

## Features
- `tar.gz` archives with timestamps
- destination safety checks
- dry-run and verbose modes
- configurable retention
- SHA-256 checksum when available
- small manifest beside each archive
- removes failed partial archives
- reports archive size

## Usage
```bash
chmod +x backup-manager.sh
./backup-manager.sh ~/Documents ~/linux-backups
./backup-manager.sh --keep 5 ~/Documents ~/linux-backups
./backup-manager.sh --dry-run ~/Documents ~/linux-backups
./backup-manager.sh --no-checksum ~/Documents ~/linux-backups
```

## Output
A normal backup creates the archive plus a manifest. By default it also creates `<archive>.sha256` when `sha256sum` or `shasum` is available.

## Concepts
Shell arrays, option parsing, path normalization, `tar`, checksums, manifests, `find`, `sort`, retention and failure cleanup.