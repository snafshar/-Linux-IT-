# Process troubleshooting

```bash
ps aux
pgrep -a ssh
 top
jobs -l
```

Prefer graceful termination first: `kill -TERM PID`. Check the process state before considering `kill -KILL PID`; force-killing may lose unsaved work.