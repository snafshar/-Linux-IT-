# awk Text Processing Exercises

Create a sample file:
```bash
printf 'alice 12\nbob 7\ncarol 19\n' > scores.txt
```

Examples:
```bash
awk '{print $1}' scores.txt
awk '{sum += $2} END {print "total:", sum}' scores.txt
awk '$2 >= 10 {print $1, $2}' scores.txt
awk 'BEGIN {FS=","} NR==1 {print "Header:", $0}' data.csv
```

Try sorting the output numerically, handling empty input, and explaining why whitespace-separated parsing is not a full CSV parser. Remove only the sample file when finished.
