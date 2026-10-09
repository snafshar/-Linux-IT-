# Linux Backup Manager

A Bash utility for timestamped compressed backups, verification metadata, and retention cleanup.

## Features

- timestamped tar.gz archives
- normalized source and destination paths
- refuses to place the backup directory inside the source
- dry-run and verbose modes
- optional SHA-256 checksum
- manifest containing source and creation time
- retention of the newest N archives
- removes partial archives if tar fails

## Usage

    ./backup-manager.sh ~/Documents ~/linux-backups
    ./backup-manager.sh --keep 5 ~/Documents ~/linux-backups
    ./backup-manager.sh --dry-run ~/Documents ~/linux-backups
    ./backup-manager.sh --no-checksum ~/Documents ~/linux-backups

Keep backups on a separate disk or trusted remote destination for stronger protection. Retention cleanup is destructive to older archives in the chosen backup directory, so verify the destination before enabling it.
