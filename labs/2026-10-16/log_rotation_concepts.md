# Log Rotation Concepts

Log rotation prevents logs from consuming unlimited disk space.

- Inspect existing policy before changing it.
- Understand size-based versus time-based rotation.
- Check whether applications reopen log files after rotation.
- Keep retention aligned with operational and legal requirements.
- Compress older logs only when applications and support workflows permit.
- Avoid deleting active logs manually; use the system's configured rotation mechanism.

On many Linux systems, review `/etc/logrotate.conf` and files under `/etc/logrotate.d/`. Do not force rotation on a production host without understanding the impact.
