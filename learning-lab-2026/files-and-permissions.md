# Files and permissions

## Inspect
```bash
pwd
ls -lah
stat example.txt
file example.txt
```

## Change permissions
```bash
chmod u+rw,go-rwx example.txt
chmod 750 scripts
chown "$USER":"$(id -gn)" example.txt
```

Use `sudo` only when required. Practice in a temporary directory and inspect changes with `stat`.