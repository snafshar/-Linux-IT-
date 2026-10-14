# Safe network diagnostics

This folder focuses on calculations and inspection of systems you own or are
authorised to administer.

## Useful commands

- `ip addr`: inspect local interface addresses.
- `ip route`: inspect the local routing table.
- `ss -tuln`: list local listening TCP/UDP sockets.
- `resolvectl status`: inspect resolver configuration on systems using systemd-resolved.
- `ping -c 4 127.0.0.1`: check the local IPv4 loopback path.
- `getent hosts example.com`: query configured name-service resolution.

Command availability varies by distribution. Do not interpret a single test as
proof that a remote service is healthy; firewalls, routing, DNS, and service state
can affect results differently.
