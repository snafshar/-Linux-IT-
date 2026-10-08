# Linux System Monitor

A Bash resource monitor with human-readable and automation-friendly output.

## Features
- CPU/load, memory and root-disk metrics
- configurable memory and disk warning thresholds
- top CPU processes
- JSON output
- continuous watch mode
- validation and clean signal handling

## Usage
```bash
chmod +x system-monitor.sh
./system-monitor.sh
./system-monitor.sh --json
./system-monitor.sh --watch 5
./system-monitor.sh --mem-warn 85 --disk-warn 75
```

## Concepts
Bash functions, option parsing, `/proc/loadavg`, `free`, `df`, `ps`, `awk`, loops, traps and exit codes.