# Linux Backup Manager

A small Bash utility that creates compressed, timestamped `tar.gz` backups.

## Usage

```bash
chmod +x backup-manager.sh
./backup-manager.sh ~/Documents ~/linux-backups
```

The first argument is the directory to back up. The second is where the archive is stored.

## Concepts practiced

- positional parameters
- input validation
- directory creation
- absolute paths
- timestamps
- `tar` compression
- exit status checking
- shell scripting
