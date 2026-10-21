# Disk usage checks

```bash
df -h
 du -sh ~/Downloads
 du -h --max-depth=1 "$HOME" 2>/dev/null | sort -h
find "$HOME" -type f -size +500M -print 2>/dev/null
```

Review output before deleting files. Avoid running destructive cleanup commands copied from unknown sources.