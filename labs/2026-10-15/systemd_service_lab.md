# systemd Service Investigation

Use a service you recognize; do not restart production services as an experiment.

```bash
systemctl status NetworkManager
systemctl is-enabled NetworkManager
systemctl is-active NetworkManager
journalctl -u NetworkManager --since "30 minutes ago" --no-pager
systemctl list-units --type=service --state=failed
```

## Questions
1. What is the difference between active and enabled?
2. Which log entry most clearly explains a failed start?
3. How would you limit journal output to the current boot?
4. Why should you read a unit's status before restarting it?

## Notes
- Unit names differ between distributions; replace `NetworkManager` if needed.
- `systemctl status` and `journalctl` are primarily investigative commands.
- Starting, stopping, enabling, or restarting services changes system state and may require elevated privileges.
