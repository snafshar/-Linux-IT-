# Linux & IT Practice Lab

A hands-on portfolio covering Linux administration, Bash automation, backup safety, system monitoring, network troubleshooting, and virtual network emulation.

## Projects

| Project | Purpose | Main concepts |
|---|---|---|
| System Monitor | Inspect system health | load, memory, disk, processes, thresholds, JSON |
| Backup Manager | Create and retain archives | tar, checksums, manifests, retention, safe paths |
| Networking Toolkit | Diagnose local and remote connectivity | interfaces, routes, DNS, sockets, ping |
| Network Health Report | Summarise live interface/address/route/DNS state | ip, resolvectl, Bash, diagnostics |
| Mininet Campus Lab | Build virtual campus and SDN networks | namespaces, Open vSwitch, OpenFlow, Ryu, traffic control |
| Enterprise SDN Simulation | Model 100 users and 5 servers | topology, MAC learning, flow installation, repeatable tests |
| [NetCheck](https://github.com/snafshar/-Linux-IT-/tree/main/projects/2026-10-16/netcheck) | Read-only connectivity diagnostics | routes, name resolution, bounded ping |
| [SysOps Toolkit](https://github.com/snafshar/-Linux-IT-/tree/main/labs/2026-10-19/sysops-toolkit) | Small administration scripts | system report, checksums, logs, process snapshot, permissions |
| [Networking notes](https://github.com/snafshar/-Linux-IT-/tree/main/labs/2026-10-19/networking) | Learn IP, DNS, TCP/UDP, and subnetting | troubleshooting and exercises |

## Quick start

    git clone https://github.com/snafshar/-Linux-IT-.git
    cd -Linux-IT-
    ./projects/system-monitor/system-monitor.sh
    ./projects/networking/network-info.sh
    ./projects/networking/network-health-report.sh
    bash labs/2026-10-19/sysops-toolkit/test_toolkit.sh

Mininet labs require a Linux host with Mininet and Open vSwitch installed. SDN labs additionally require Ryu. Launch scripts use sudo because Mininet creates network namespaces. Most SysOps Toolkit scripts only inspect state and do not require elevated permissions.
