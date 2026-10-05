# Linux System Monitor

A practical Bash system-health utility for inspecting a Linux machine from the terminal.

## Features

- Hostname, kernel and uptime information
- CPU core count and load average
- Memory utilization
- Root filesystem utilization
- Top CPU-consuming processes
- Disk warning when root usage reaches 70%
- JSON output for scripting and automation
- Watch mode for continuously refreshed monitoring
- Command-line help and input validation

## Usage

```bash
chmod +x system-monitor.sh
./system-monitor.sh
```

JSON output:

```bash
./system-monitor.sh --json
```

Continuous monitoring:

```bash
./system-monitor.sh --watch 5
```

Press `Ctrl+C` to stop watch mode.

## Concepts practiced

- Bash functions and local variables
- positional and optional arguments
- `case` statements, loops and traps
- `/proc/loadavg`
- `free`, `df`, `ps`, `awk`, and `nproc`
- pipes, redirection and command substitution
- automation-friendly output
- exit codes and defensive scripting