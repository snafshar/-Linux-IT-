# Log Review Workflow

1. Identify the service, host, and time window.
2. Use `journalctl -u SERVICE --since '30 minutes ago'` for systemd-managed services.
3. Filter by severity only after preserving the surrounding context.
4. Correlate the event with deployment, configuration, and resource changes.
5. Redact tokens, session IDs, personal data, and private hostnames before sharing excerpts.
6. Record the hypothesis, evidence, and next diagnostic step.

A repeated error is evidence of frequency, not proof of root cause. Compare timestamps with metrics and dependency status.
