# NetCheck — Network Diagnostics Lab

NetCheck is a read-only Bash script for practicing basic Linux network troubleshooting. It reports the local hostname, default route, address lookup, and a short ping result.

## Requirements

- Bash
- Optional tools: `hostname`, `ip`, `getent`, `awk`, `ping`, and `date`
- No root privileges are required.

## Usage

```bash
chmod +x netcheck.sh
./netcheck.sh
./netcheck.sh example.com
./netcheck.sh 1.1.1.1
```

The script accepts zero or one hostname/IP argument. Invalid input and extra arguments produce a usage error. The script does not edit network settings.

## Checks explained

| Check | Command / idea | Interpretation |
|---|---|---|
| Hostname | `hostname` | Identifies the local machine |
| Default route | `ip route show default` | Shows the configured default gateway, if any |
| Name/address lookup | `getent ahosts` | Uses the system name-service configuration |
| Reachability | `ping -c 1 -W 2` | Sends one bounded ICMP echo request |

## Exercises

1. Compare results for a domain name and a numeric IP address.
2. Explain why DNS can succeed while ping fails.
3. Inspect the default route using `ip route` and compare it with NetCheck output.
4. Add a command-line option to configure the ping timeout.
5. Test behavior when one optional tool is missing.

## Limitations

A failed ping is not proof that a host is offline: ICMP may be filtered, the route may be unavailable, or the destination may not respond. A DNS lookup can return multiple addresses, and local name-service policy affects `getent` results. NetCheck is a learning aid, not a complete network monitor.
