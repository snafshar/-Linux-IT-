# SysOps Toolkit

Small, read-only Bash utilities for learning everyday Linux administration. The scripts are intended for Linux systems with common command-line utilities and do not attempt to change system configuration.

## Tools

- `sysinfo.sh`: operating-system, kernel, uptime, and hostname summary.
- `disk_report.sh`: filesystem usage report.
- `log_summary.sh`: counts common severity terms in a log file.
- `checksum_manifest.sh`: creates a SHA-256 manifest for supplied files.
- `backup_preview.sh`: previews a copy operation without writing files.
- `port_listeners.sh`: lists local listening sockets when `ss` is available.
- `process_snapshot.sh`: shows the top processes by CPU and memory.
- `env_report.sh`: prints a small allow-list of useful environment metadata.
- `permission_audit.sh`: finds world-writable files beneath a user-selected directory.

## Run

```bash
chmod +x *.sh
./sysinfo.sh
./disk_report.sh
./log_summary.sh /var/log/syslog
./checksum_manifest.sh README.md
./backup_preview.sh ./docs ./backup
```

Some distributions use a different system log path. Missing optional commands are reported rather than treated as fatal. Avoid running permission audits across directories you do not have permission to inspect.
