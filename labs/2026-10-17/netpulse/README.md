# NetPulse — Linux Diagnostics Toolkit

NetPulse is a small, safe Bash project for checking local network readiness from a Linux terminal. It reports interface addresses, the default route, resolver configuration, and optional connectivity checks.

## Run

    chmod +x netpulse.sh
    ./netpulse.sh
    ./netpulse.sh example.com

The external connectivity check is optional and uses the system ping command. The script does not scan ports, change network settings, or require root privileges.

## Concepts practiced

- Bash functions, arguments, exit codes, and quoting
- Linux networking commands: ip, getent, and ping
- Graceful handling when a command is unavailable
- Writing readable diagnostic output

## Project extensions

1. Add a --json output mode.
2. Add a timeout option with validation.
3. Write results to a timestamped log file.
4. Add shell tests using mocked command output.
