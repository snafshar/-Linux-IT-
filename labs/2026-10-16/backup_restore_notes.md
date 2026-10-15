# Backup and Restore Verification

A successful archive command is not enough to prove that a backup is useful.

- Record the source, timestamp, archive size, and exit status.
- List archive contents with `tar -tzf backup.tar.gz`.
- Test extraction into a new temporary directory.
- Compare a few known files or checksums.
- Keep backups separate from the source filesystem when possible.
- Define retention and protect sensitive data with appropriate permissions.
- Practise restoration before depending on a backup for recovery.

Never test restoration by overwriting the original source directory.
