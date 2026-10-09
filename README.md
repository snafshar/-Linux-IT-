# Linux & IT Practice Lab

A hands-on portfolio covering Linux administration, Bash automation, backup safety, system monitoring, network troubleshooting, and virtual network emulation.

## Projects

| Project | Purpose | Main concepts |
|---|---|---|
| System Monitor | Inspect system health | load, memory, disk, processes, thresholds, JSON |
| Backup Manager | Create and retain archives | tar, checksums, manifests, retention, safe paths |
| Networking Toolkit | Diagnose local and remote connectivity | interfaces, routes, DNS, sockets, ping |
| Mininet Campus Lab | Build virtual campus and SDN networks | namespaces, Open vSwitch, OpenFlow, Ryu, traffic control |
| Enterprise SDN Simulation | Model 100 users and 5 servers | topology, MAC learning, flow installation, repeatable tests |

## Quick start

    git clone https://github.com/snafshar/-Linux-IT-.git
    cd -Linux-IT-
    ./projects/system-monitor/system-monitor.sh
    ./projects/networking/network-info.sh
    ./projects/networking/connectivity-check.sh example.com

Mininet labs require a Linux host with Mininet and Open vSwitch installed. SDN labs additionally require Ryu. Launch scripts use sudo because Mininet creates network namespaces and virtual interfaces.

## Principles

- Validate command-line input and fail with useful messages.
- Prefer read-only diagnostics for host networking.
- Keep experiments reproducible with fixed random seeds.
- Clean up virtual network state on exit.
- Explain how to run each tool and what it teaches.

## Learning path

1. Inspect Linux resources.
2. Create and verify backups.
3. Inspect interfaces, routes, DNS, and sockets.
4. Diagnose connectivity.
5. Build a routed virtual campus.
6. Explore OpenFlow and SDN control.
7. Compare repeatable traffic-test results.
