# Linux Network Diagnostics Lab

Run these commands on systems you own or are authorized to administer.

| Goal | Command | What to inspect |
|---|---|---|
| Interfaces and addresses | `ip -brief address` | Interface state and assigned addresses |
| Routing table | `ip route` | Default gateway and destination routes |
| DNS resolver config | `cat /etc/resolv.conf` | Configured resolver (may be managed) |
| Name lookup | `getent hosts example.com` | System name-service resolution |
| Socket summary | `ss -tuln` | Listening TCP/UDP sockets |
| Active connections | `ss -tun` | Current TCP/UDP endpoints |
| Path to destination | `tracepath example.com` | Hops where supported |
| HTTP response headers | `curl -I --max-time 10 https://example.com` | Status and response headers |
| Packet counters | `ip -s link` | RX/TX errors and drops |

## Suggested workflow
1. Check link and address configuration.
2. Check the route chosen for the destination.
3. Test name resolution independently.
4. Test application connectivity with a bounded timeout.
5. Compare counters before and after a controlled test.

A failed ping does not necessarily mean a host is down: ICMP may be filtered.
