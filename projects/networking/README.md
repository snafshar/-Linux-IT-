# Linux-IT Networks

A read-only Linux networking toolkit for inspection and connectivity troubleshooting.

## Tools
- `network-info.sh` — interfaces, addresses, routes, DNS and listening sockets
- `connectivity-check.sh` — interface, route, DNS, gateway and target connectivity tests

## Examples
```bash
chmod +x *.sh
./network-info.sh
./network-info.sh --interface eth0
./network-info.sh --json
./connectivity-check.sh
./connectivity-check.sh --count 2 --timeout 5 example.com
```

## Learning goals
- interfaces and IP addressing
- IPv4/IPv6 routing
- default gateways
- DNS resolution
- TCP/UDP sockets
- ICMP diagnostics
- exit codes and automation

## Safety
The scripts inspect network state only. They do not modify interfaces, routes, DNS, firewall rules or other network configuration.