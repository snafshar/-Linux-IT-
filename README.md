# Linux & IT Practice Lab

A small collection of practical Linux projects, shell scripts, and command-line experiments.

## Projects

### 1. Linux System Monitor
A Bash-based system health checker reporting host/kernel information, CPU and memory usage, disk usage, uptime, logged-in users, and top CPU-consuming processes.

```bash
chmod +x projects/system-monitor/system-monitor.sh
./projects/system-monitor/system-monitor.sh
```

### 2. Linux Backup Manager
A lightweight Bash utility for creating timestamped compressed backups of a selected directory.

```bash
chmod +x projects/backup-manager/backup-manager.sh
./projects/backup-manager/backup-manager.sh ~/Documents ~/linux-backups
```

## Learning goals

The repository is intentionally practical and beginner-friendly, covering Linux administration, Bash scripting, files and permissions, processes, system information, automation, and command-line problem solving.

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
