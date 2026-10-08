# Connectivity Check

Diagnose common Linux connectivity problems without changing network configuration.

## Usage
```bash
./connectivity-check.sh
./connectivity-check.sh --count 2 --timeout 5 example.com
```

## Checks
1. An interface is up
2. A default route exists
3. DNS resolves the target
4. The default gateway responds when `ping` is available
5. The target responds when `ping` is available

## Exit status
- `0` — all required checks passed
- `1` — one or more checks failed
- `2` — invalid command-line usage

## Workflow
Start with `network-info.sh`, then use this diagnostic to isolate interface, routing, DNS and reachability problems.