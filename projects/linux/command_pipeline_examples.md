# Linux command pipeline examples

These examples read local files and display summaries.

```bash
# Count lines in a text file
wc -l < notes.txt

# Find the ten largest entries in a directory listing
du -ah ./data | sort -h | tail -n 10

# Count distinct first-column values
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head

# Search recursively, showing line numbers
grep -Rni --include='*.py' 'TODO' ./src

# Show the last 100 lines and follow new entries
tail -n 100 application.log
```

Check paths before running commands, and avoid piping untrusted filenames into shell
evaluation constructs such as `eval`.
