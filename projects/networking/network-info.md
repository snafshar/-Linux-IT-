# Network Info

Read-only Linux network inspection tool.

## Usage
```bash
./network-info.sh
./network-info.sh --interface eth0
./network-info.sh --json
```

## Reports
Human-readable mode shows interface addresses, IPv4/IPv6 routes, DNS information and listening TCP/UDP sockets. JSON mode emits a compact summary for shell automation.

## Commands
`ip`, `ss`, `resolvectl`, `awk`, `sed`.