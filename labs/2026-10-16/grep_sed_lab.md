# grep and sed Exercises

Create a sample file in a temporary directory and practise:
```bash
grep -n 'ERROR' application.log
grep -i 'warning' application.log
grep -E 'ERROR|CRITICAL' application.log
sed -n '1,20p' application.log
sed 's/old/new/g' sample.txt
```

The final sed example writes transformed text to stdout; it does not modify the file in place. Test regular expressions against a small sample and avoid editing real logs during practice.
