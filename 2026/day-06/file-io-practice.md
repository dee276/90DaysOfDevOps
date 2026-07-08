# Day 06 - File I/O Practice

## Commands run

### 1. Create an empty file
```bash
touch notes.txt
```
Created a new file named `notes.txt`.

### 2. Write Line 1 using redirection
```bash
echo "Line 1" > notes.txt
```
Wrote the first line into the file and replaced any existing content.

### 3. Append Line 2
```bash
echo "Line 2" >> notes.txt
```
Appended a second line to the file.

### 4. Append Line 3 and display it at the same time
```bash
echo "Line 3" | tee -a notes.txt
```
Added a third line and printed it to the terminal as well.

### 5. Read the full file
```bash
cat notes.txt
```
Output:
```text
Line 1
Line 2
Line 3
```

### 6. Read the first two lines
```bash
head -n 2 notes.txt
```
Output:
```text
Line 1
Line 2
```

### 7. Read the last two lines
```bash
tail -n 2 notes.txt
```
Output:
```text
Line 2
Line 3
```

## Notes
- `>` overwrites the file content.
- `>>` appends to the file.
- `tee -a` is useful when you want to both write to a file and see the output in the terminal.
