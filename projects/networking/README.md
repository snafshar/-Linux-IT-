# Linux Networking Toolkit

A read-only Bash toolkit for examining network configuration and troubleshooting reachability.

## Tools

- network-info.sh — interfaces, addresses, routes, DNS configuration, and listening sockets
- connectivity-check.sh — default route, name resolution, ping, sockets, and interface summary

## Examples

    ./network-info.sh
    ./network-info.sh --interface eth0
    ./network-info.sh --json
    ./connectivity-check.sh
    ./connectivity-check.sh --count 2 --timeout 5 example.com

The interface name depends on the host; inspect the interface summary first.

## Learning goals

- IPv4/IPv6 interfaces and addressing
- routing tables and default gateways
- DNS resolution
- TCP/UDP listening sockets
- ICMP diagnostics
- shell argument validation and automation

The scripts inspect state only; they do not change interfaces, routes, DNS, or firewall rules.
