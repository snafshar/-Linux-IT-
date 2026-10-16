# NetCheck — Network Diagnostics Lab

A small, read-only Bash lab for checking basic network connectivity on Linux.

## Usage

```bash
chmod +x netcheck.sh
./netcheck.sh
./netcheck.sh example.com
```

The script reports the host name, default route when available, DNS lookup result, and whether a short ping test succeeds. It does not change network settings or require root privileges.

## Learning goals

- Use command exit codes to report success or failure.
- Inspect routes with `ip route`.
- Resolve host names with `getent hosts`.
- Use bounded connectivity checks.
- Keep diagnostic output readable and safe.

## Limitations

A failed ping does not prove that a host is down: ICMP may be filtered. DNS and route checks are best-effort and depend on installed system tools.
