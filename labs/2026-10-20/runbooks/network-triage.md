# Network Connectivity Triage

1. Check interface/address state with `ip -br addr`.
2. Inspect routes with `ip route`.
3. Test the configured gateway where ICMP is allowed.
4. Resolve hostnames using `getent ahosts example.com` or the platform DNS utility.
5. Inspect sockets with `ss -tulpn`; permissions may hide process details.
6. Record timestamps, exact errors, interface, destination, and intermittency.
7. Do not scan third-party hosts or change firewalls without authorization.