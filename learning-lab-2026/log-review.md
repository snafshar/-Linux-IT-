# Log review checklist

1. Confirm the timestamp and timezone.
2. Read service status: `systemctl status SERVICE`.
3. Inspect recent journal entries: `journalctl -u SERVICE --since '30 minutes ago'`.
4. Search for errors around the first failure, not just the final stack trace.
5. Record the command, expected result, actual result, and next test.