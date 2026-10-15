# Linux & Shell Practice Lab

This lab is designed to be run on a personal Linux machine or in a disposable VM.

## Labs
1. `process_audit.sh` — inspect processes and report top CPU/RAM consumers.
2. `disk_audit.sh` — summarize mounted filesystems and warn about high usage.
3. `log_summary.py` — count common severity labels in a text log.
4. `backup_verify.sh` — create an archive and verify that it can be listed.

## Safe-use notes
- Scripts are read-only unless their names or documentation explicitly say otherwise.
- Test with a temporary directory before using real data.
- Never run scripts as root unless a task explicitly requires it.
- Review commands before adapting them to production systems.

## Run
```bash
chmod +x process_audit.sh disk_audit.sh backup_verify.sh
./process_audit.sh
./disk_audit.sh
python3 log_summary.py /var/log/syslog
```

On distributions without `/var/log/syslog`, use a readable log file available on your system.
