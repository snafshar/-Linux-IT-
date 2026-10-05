# Linux & IT Practice Lab

A practical collection of Linux administration exercises, Bash utilities, and command-line projects.

## Projects

| Project | Purpose | Main topics |
|---|---|---|
| **Linux System Monitor** | Inspect system health from the terminal | Bash, processes, memory, CPU, disk, JSON, watch mode |
| **Linux Backup Manager** | Create and maintain compressed backups | Bash, `tar`, validation, retention, safe paths |

## Quick start

```bash
git clone https://github.com/snafshar/-Linux-IT-.git
cd -Linux-IT-
chmod +x projects/system-monitor/system-monitor.sh
./projects/system-monitor/system-monitor.sh
chmod +x projects/backup-manager/backup-manager.sh
./projects/backup-manager/backup-manager.sh --dry-run ~/Documents ~/linux-backups
```

## Learning goals

This repository is designed as a small portfolio and learning lab. It focuses on practical command-line problem solving rather than isolated syntax examples.

Topics include:

- Linux system inspection
- Bash scripting
- files, directories and permissions
- processes and resource usage
- command-line argument parsing
- compression and backups
- error handling and cleanup
- automation-friendly output
- defensive shell programming

## Structure

```text
projects/
├── system-monitor/
│   ├── system-monitor.sh
│   └── README.md
└── backup-manager/
    ├── backup-manager.sh
    └── README.md
```

## Status

The projects are intentionally small enough to understand line by line, while including patterns that are useful in real Linux scripting.