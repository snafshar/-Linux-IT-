# Connectivity Check

A small diagnostic script for identifying common Linux network connectivity problems.

## Usage
```bash
chmod +x connectivity-check.sh
./connectivity-check.sh
./connectivity-check.sh example.com
```

## Checks
- an interface is up
- a default route exists
- the default gateway responds
- DNS can resolve the target
- the target is reachable

## Exit status
- `0` — all checks passed
- `1` — at least one check failed
- `2` — invalid command-line usage

## Troubleshooting workflow
1. Run `network-info.sh`.
2. Check whether an interface has an IP address.
3. Check the default route.
4. Check DNS configuration.
5. Run `connectivity-check.sh` against a known host.