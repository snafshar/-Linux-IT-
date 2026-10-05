# Linux & IT Practice Lab

A practical collection of Linux administration exercises, Bash utilities, networking tools, and command-line projects.

## Projects

| Project | Purpose | Main topics |
|---|---|---|
| **Linux System Monitor** | Inspect system health from the terminal | Bash, processes, memory, CPU, disk, JSON, watch mode |
| **Linux Backup Manager** | Create and maintain compressed backups | Bash, `tar`, validation, retention, safe paths |
| **Linux-IT Networks** | Inspect and troubleshoot Linux networking | Interfaces, IP, routing, DNS, sockets, connectivity |

## Quick start

```bash
git clone https://github.com/snafshar/-Linux-IT-.git
cd -Linux-IT-
chmod +x projects/system-monitor/system-monitor.sh
./projects/system-monitor/system-monitor.sh
chmod +x projects/backup-manager/backup-manager.sh
./projects/backup-manager/backup-manager.sh --dry-run ~/Documents ~/linux-backups
chmod +x projects/networking/*.sh
./projects/networking/network-info.sh
./projects/networking/connectivity-check.sh
```

## Learning goals

Practical command-line problem solving across Linux administration, Bash, system monitoring, backups, and networking.

Topics include:

- Linux system inspection
- Bash scripting
- files, directories and permissions
- processes and resource usage
- command-line argument parsing
- compression and backups
- network interfaces and IP addressing
- routing and default gateways
- DNS and name resolution
- TCP/UDP listening sockets
- connectivity troubleshooting
- error handling and defensive scripting

## Structure

```text
projects/
├── system-monitor/
├── backup-manager/
└── networking/
    ├── README.md
    ├── network-info.sh
    ├── network-info.md
    ├── connectivity-check.sh
    └── connectivity-check.md
```