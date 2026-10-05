# Linux-IT Networks

A practical Linux networking toolkit for learning network inspection, diagnostics, DNS, routing, sockets, and connectivity testing from the command line.

## Included tools

- `network-info.sh` — summarizes interfaces, IP addresses, routes, DNS and listening sockets
- `connectivity-check.sh` — checks local network configuration, DNS resolution, gateway reachability and Internet connectivity

## Quick start

```bash
chmod +x network-info.sh connectivity-check.sh
./network-info.sh
./connectivity-check.sh
```

## Learning goals

- Linux network interfaces and IP addressing
- IPv4 and IPv6 basics
- routing tables and default gateways
- DNS configuration and name resolution
- TCP/UDP listening sockets
- connectivity troubleshooting
- `ip`, `ss`, `ping`, `getent`, `resolvectl` and `awk`

## Note

The scripts are intentionally read-only: they inspect the system but do not change network configuration.