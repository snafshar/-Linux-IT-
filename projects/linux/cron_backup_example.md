# Scheduled backup example

Prefer a user-owned script with a known absolute path and a log file. Test the
script manually before scheduling it.

Example crontab entry (edit with `crontab -e`):

```cron
# Run a personal backup at 02:30 every day; replace paths before use.
30 2 * * * /home/USER/bin/backup.sh >> /home/USER/backup.log 2>&1
```

Checklist:
- Use absolute paths because cron has a minimal environment.
- Ensure the output directory exists and has suitable permissions.
- Keep secrets out of command lines and logs.
- Test restore procedures, not only archive creation.
- Monitor free disk space and retention.
