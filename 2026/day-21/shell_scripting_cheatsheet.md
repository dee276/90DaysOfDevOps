# Shell Scripting Cheat Sheet

## Quick Reference Table

| Topic | Key Syntax | Example |
|-------|-----------|---------|
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Argument | `$0`, `$1`, `$2`, `$#`, `$@` | `./script.sh arg1 arg2` |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| For loop | `for item in list; do` | `for i in 1 2 3; do` |
| While loop | `while [ condition ]; do` | `while [ "$n" -gt 0 ]; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |

---

## Basics

### Shebang
```bash
#!/bin/bash
```
Indicates the script interpreter. It ensures the script runs with Bash.

### Running a script
```bash
chmod +x script.sh
./script.sh
bash script.sh
```
Use `chmod +x` to make the file executable, then run it directly or with Bash.

### Comments
```bash
# This is a single-line comment
echo "Hello" # inline comment
```
Comments document the code and are ignored by the shell.

### Variables
```bash
NAME="DevOps"
echo "$NAME"
```
Use `$VAR` for expansion; quote variables as `"$VAR"` to preserve spaces.

### Reading input
```bash
read -p "Enter value: " value
echo "You entered: $value"
```
`read` stores user input into a variable.

### Command-line arguments
```bash
echo "Script: $0"
echo "First arg: $1"
echo "Count: $#"
echo "All args: $@"
```
Use `$#` for argument count and `$@` for all arguments.

---

## Operators and Conditionals

### String comparisons
```bash
if [ "$a" = "$b" ]; then
  echo "same"
fi
if [ -z "$a" ]; then
  echo "empty"
fi
```
`=` and `!=` compare strings; `-z` checks empty, `-n` checks non-empty.

### Integer comparisons
```bash
if [ "$x" -eq 10 ]; then
  echo "equal"
fi
if [ "$x" -gt 5 ]; then
  echo "greater"
fi
```
Use `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge` for numeric tests.

### File tests
```bash
if [ -f file.txt ]; then echo "file exists"; fi
if [ -d /tmp ]; then echo "directory exists"; fi
if [ -x script.sh ]; then echo "executable"; fi
```
`-f` file, `-d` directory, `-e` exists, `-r` readable, `-w` writable, `-x` executable, `-s` non-empty.

### If / elif / else
```bash
if [ "$val" = "yes" ]; then
  echo "yes"
elif [ "$val" = "no" ]; then
  echo "no"
else
  echo "other"
fi
```
Use `elif` for additional branches.

### Logical operators
```bash
command1 && command2
command1 || command2
if [ -f file ] && [ -r file ]; then
  echo "ok"
fi
```
`&&` runs next on success, `||` runs next on failure.

### Case statements
```bash
case "$choice" in
  start)
    echo "starting" ;;
  stop)
    echo "stopping" ;;
  *)
    echo "unknown" ;;
esac
```
Great for matching multiple options.

---

## Loops

### For loop
```bash
for item in apple banana cherry; do
  echo "$item"
done
```
Iterates over a list of values.

### C-style for loop
```bash
for ((i=1; i<=5; i++)); do
  echo "$i"
done
```
Useful for numeric iteration.

### While loop
```bash
count=5
while [ "$count" -gt 0 ]; do
  echo "$count"
  count=$((count - 1))
done
```
Runs while the condition is true.

### Until loop
```bash
count=0
until [ "$count" -ge 5 ]; do
  echo "$count"
  count=$((count + 1))
done
```
Runs until the condition becomes true.

### Loop control
```bash
for n in 1 2 3 4; do
  if [ "$n" -eq 3 ]; then
    continue
  fi
  echo "$n"
  if [ "$n" -eq 4 ]; then
    break
  fi
done
```
`break` exits the loop, `continue` skips to next iteration.

### Loop over files
```bash
for file in *.log; do
  echo "$file"
done
```
Process matching files easily.

### Loop over command output
```bash
ls /tmp | while read -r line; do
  echo "$line"
done
```
`read -r` preserves backslashes and spaces.

---

## Functions

### Define a function
```bash
hello() {
  echo "Hello"
}
```
Use `name() { }` to group reusable code.

### Call a function
```bash
hello
```
Functions run like commands.

### Arguments inside functions
```bash
greet() {
  echo "Hello, $1!"
}
greet "Shubham"
```
Function arguments use `$1`, `$2`.

### Return values
```bash
add() {
  echo "$(( $1 + $2 ))"
}
result=$(add 3 4)
echo "$result"
```
Use `echo` for values, `return` only sets exit code.

### Local variables
```bash
demo() {
  local value="local"
  echo "$value"
}
demo
```
`local` keeps variables inside the function.

---

## Text Processing Commands

### grep
```bash
grep -i "error" logfile.log
grep -n "CRITICAL" file.log
grep -c "WARNING" file.log
```
Search text with case-insensitive, line numbers, and counts.

### awk
```bash
awk '{print $1, $2}' file.txt
awk -F: '{print $1}' /etc/passwd
awk 'BEGIN {OFS=","} $3 > 100 {print $1, $3}'
```
Powerful column-based text processing.

### sed
```bash
sed 's/old/new/g' file.txt
sed -n '1,5p' file.txt
sed -i 's/foo/bar/g' file.txt
```
Stream edits, substitutions and in-place changes.

### cut
```bash
cut -d ':' -f 1 /etc/passwd
cut -c 1-10 file.txt
```
Extract fields or characters from lines.

### sort
```bash
sort file.txt
sort -nr numbers.txt
sort -u file.txt
```
Sort alphabetically, numerically, reverse, or unique.

### uniq
```bash
sort file.txt | uniq
sort file.txt | uniq -c
```
Combine with `sort` to deduplicate and count.

### tr
```bash
echo "foo" | tr 'a-z' 'A-Z'
echo "a b" | tr -d ' '
```
Translate or delete characters.

### wc
```bash
wc -l file.txt
wc -w file.txt
wc -c file.txt
```
Count lines, words, and characters.

### head / tail
```bash
head -n 10 file.log
tail -n 10 file.log
tail -f file.log
```
Read the top or bottom of files and follow live logs.

---

## Useful Patterns and One-Liners

### Find and delete old files
```bash
find /tmp -type f -mtime +30 -delete
```
Delete files older than 30 days.

### Count lines in all `.log` files
```bash
find . -name '*.log' -exec wc -l {} +
```
Count lines across multiple log files.

### Replace a string across files
```bash
grep -rl "old" . | xargs sed -i 's/old/new/g'
```
Search and replace across many files.

### Check if a service is running
```bash
if systemctl is-active --quiet nginx; then
  echo "nginx is running"
fi
```
Quick service health check.

### Monitor disk usage with alert
```bash
if [ $(df / | tail -1 | awk '{print $5}' | tr -d '%') -gt 80 ]; then
  echo "Disk > 80%"
fi
```
Trigger actions when disk usage is high.

### Tail a log and filter errors
```bash
tail -f /var/log/syslog | grep --line-buffered -i error
```
Real-time log filtering.

---

## Error Handling and Debugging

### Exit codes
```bash
command
if [ "$?" -ne 0 ]; then
  echo "Command failed"
fi
exit 1
```
`$?` holds the last command status.

### set -e
```bash
set -e
```
Stop the script if any command fails.

### set -u
```bash
set -u
```
Treat unset variables as errors.

### set -o pipefail
```bash
set -o pipefail
```
Fail a pipeline if any command in it fails.

### set -x
```bash
set -x
```
Print each command before execution for debugging.

### trap
```bash
cleanup() {
  echo "Cleaning up"
}
trap cleanup EXIT
```
Run cleanup code when the script exits.

---

## Notes
- Keep scripts readable with functions and comments.
- Quote variables to avoid word-splitting problems.
- Test your scripts with sample input before using them in production.
