# Linux System Monitor

A Bash monitor for host load, memory use, root filesystem capacity, and high-CPU processes.

## Usage

    ./system-monitor.sh
    ./system-monitor.sh --json
    ./system-monitor.sh --watch 5
    ./system-monitor.sh --mem-warn 85 --disk-warn 75

Threshold values are percentages from 0 to 100. Watch mode refreshes at the chosen interval; Ctrl+C stops it.

## Implementation notes

Uses common Linux tools and procfs data. Some metrics require utilities such as free, df, ps, awk, and uptime. JSON mode is intended for simple automation; human-readable mode is better for interactive troubleshooting.
