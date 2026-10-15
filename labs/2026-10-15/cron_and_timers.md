# Scheduling Tasks: cron and systemd timers

## Inspect existing schedules
```bash
crontab -l
systemctl list-timers --all
```

## Cron format
`minute hour day-of-month month day-of-week command`

Example (runs every day at 02:15):
```cron
15 2 * * * /home/user/bin/backup.sh
```

Use absolute paths, log output deliberately, and test scripts manually before scheduling them. Cron has a smaller environment than an interactive shell.

## systemd timers
A timer unit can trigger a service and supports journal logging and dependency management. Inspect existing timer/service pairs with `systemctl list-timers` and `systemctl cat UNIT.timer`.

Do not install or enable a recurring job until its scope, permissions, retention policy, and failure behavior are understood.
