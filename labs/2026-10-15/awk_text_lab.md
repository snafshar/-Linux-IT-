# awk Text Processing Exercises

Create a sample:
```bash
printf 'alice 12\nbob 7\ncarol 19\n' > scores.txt
```
Try:
```bash
awk '{print $1}' scores.txt
awk '{sum += $2} END {print "total:", sum}' scores.txt
awk '$2 >= 10 {print $1, $2}' scores.txt
```
Explain why whitespace-separated parsing is not a complete CSV parser. Remove only your sample file when finished.
