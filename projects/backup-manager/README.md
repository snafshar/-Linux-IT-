# Linux Backup Manager

A safer Bash utility for creating compressed, timestamped `tar.gz` backups of directories.

## Features

- Input validation and helpful command-line usage
- Timestamped backup archives
- Automatic creation of the destination directory
- Protection against placing backups inside the source directory
- Dry-run mode
- Verbose mode
- Optional retention policy
- Removes a partially created archive when `tar` fails
- Reports the resulting archive size

## Usage

```bash
chmod +x backup-manager.sh
./backup-manager.sh ~/Documents ~/linux-backups
```

Keep only the newest five backups:

```bash
./backup-manager.sh --keep 5 ~/Documents ~/linux-backups
```

Preview without creating an archive:

```bash
./backup-manager.sh --dry-run ~/Documents ~/linux-backups
```

Show files processed by `tar`:

```bash
./backup-manager.sh --verbose ~/Documents ~/linux-backups
```

## Concepts practiced

- Bash functions and arrays
- option parsing with `case`
- positional arguments
- absolute and normalized paths
- `tar` and gzip compression
- `find`, `sort`, `sed`, and `mapfile`
- exit-status checking
- cleanup after failure
- retention policies
- safe quoting of shell variables