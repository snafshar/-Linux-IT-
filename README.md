# Linux & IT Practice Lab

A practical portfolio and learning lab covering Linux administration, Bash scripting, backup automation, system monitoring, networking, and network emulation.

## Projects
| Project | Purpose | Topics |
|---|---|---|
| **Linux System Monitor** | Monitor resource health | CPU, memory, disk, processes, JSON, thresholds |
| **Linux Backup Manager** | Create and maintain backups | tar, checksums, manifests, retention, safety |
| **Linux-IT Networks** | Inspect and troubleshoot networking | IP, routes, DNS, sockets, connectivity |
| **Mininet Routed Campus Lab** | Build reproducible virtual networks | Mininet, namespaces, Open vSwitch, routing, traffic control, iperf |

## Quick start
```bash
git clone https://github.com/snafshar/-Linux-IT-.git
cd -Linux-IT-
chmod +x projects/*/*.sh
./projects/system-monitor/system-monitor.sh
./projects/networking/network-info.sh
./projects/networking/connectivity-check.sh
./projects/mininet-campus-lab/run-lab.sh --test
```

## Design principles
- Readable Bash and Python over unnecessary complexity
- Safe, read-only diagnostics where possible
- Explicit validation and useful exit codes
- Small tools that can be combined from the command line
- Documentation that explains both usage and concepts
- Reproducible experiments for networking practice

## Learning path
1. System inspection
2. Backup and automation
3. Network inspection
4. Network diagnostics
5. Virtual network emulation with Mininet
6. Extend the tools with logging, tests, dynamic routing, and automation

## Structure
```text
projects/
├── system-monitor/
├── backup-manager/
├── networking/
└── mininet-campus-lab/
    ├── README.md
    ├── campus_lab.py
    └── run-lab.sh
```
