# Day 16 - Shell Scripting Basics

## Environment

- Scripts created in: `2026/day-16/`
- Shell target: Bash
- Note: Some scripts are interactive, so example runs are documented with sample input.

## Script 1: `hello.sh`

Code:

```bash
#!/bin/bash

echo "Hello, DevOps!"
```

Run:

```bash
chmod +x hello.sh
./hello.sh
```

Output:

```text
Hello, DevOps!
```

What happens without the shebang:

- Running `bash hello.sh` still works because Bash is explicitly used.
- Running `./hello.sh` depends on the current shell. The script may still run for simple commands, but the system no longer knows which interpreter the script expects. For portability and predictable behavior, I should keep `#!/bin/bash`.

## Script 2: `variables.sh`

Code:

```bash
#!/bin/bash

NAME="Dee"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
echo 'With single quotes: Hello, I am $NAME and I am a $ROLE'
echo "With double quotes: Hello, I am $NAME and I am a $ROLE"
```

Output:

```text
Hello, I am Dee and I am a DevOps Engineer
With single quotes: Hello, I am $NAME and I am a $ROLE
With double quotes: Hello, I am Dee and I am a DevOps Engineer
```

Single quotes print text literally. Double quotes allow variable expansion.

## Script 3: `greet.sh`

Code:

```bash
#!/bin/bash

read -p "Enter your name: " NAME
read -p "Enter your favourite tool: " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"
```

Example run:

```text
Enter your name: Dee
Enter your favourite tool: Docker
Hello Dee, your favourite tool is Docker
```

## Script 4: `check_number.sh`

Code:

```bash
#!/bin/bash

read -p "Enter a number: " NUMBER

if [ "$NUMBER" -gt 0 ]; then
  echo "$NUMBER is positive"
elif [ "$NUMBER" -lt 0 ]; then
  echo "$NUMBER is negative"
else
  echo "$NUMBER is zero"
fi
```

Example runs:

```text
Enter a number: 5
5 is positive

Enter a number: -2
-2 is negative

Enter a number: 0
0 is zero
```

## Script 5: `file_check.sh`

Code:

```bash
#!/bin/bash

read -p "Enter a filename: " FILENAME

if [ -f "$FILENAME" ]; then
  echo "$FILENAME exists and is a regular file"
else
  echo "$FILENAME does not exist or is not a regular file"
fi
```

Example runs:

```text
Enter a filename: hello.sh
hello.sh exists and is a regular file

Enter a filename: missing.txt
missing.txt does not exist or is not a regular file
```

## Script 6: `server_check.sh`

Code:

```bash
#!/bin/bash

SERVICE_NAME="nginx"

read -p "Do you want to check the status of $SERVICE_NAME? (y/n): " ANSWER

if [ "$ANSWER" = "y" ] || [ "$ANSWER" = "Y" ]; then
  if ! command -v systemctl >/dev/null 2>&1; then
    echo "systemctl is not available in this environment"
    exit 1
  fi

  if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is active"
  else
    echo "$SERVICE_NAME is not active"
    systemctl status "$SERVICE_NAME" --no-pager
  fi
elif [ "$ANSWER" = "n" ] || [ "$ANSWER" = "N" ]; then
  echo "Skipped."
else
  echo "Invalid answer. Please enter y or n."
  exit 1
fi
```

Example outputs:

```text
Do you want to check the status of nginx? (y/n): n
Skipped.
```

In a container or minimal environment without `systemd`:

```text
Do you want to check the status of nginx? (y/n): y
systemctl is not available in this environment
```

On a full Linux VM with `systemd`, the script checks whether `nginx` is active.

## Commands Used

```bash
chmod +x hello.sh variables.sh greet.sh check_number.sh file_check.sh server_check.sh
./hello.sh
./variables.sh
./greet.sh
./check_number.sh
./file_check.sh
./server_check.sh
```

## What I Learned

- A shebang tells the OS which interpreter should run the script.
- Bash variables expand inside double quotes, but not inside single quotes.
- `read` makes scripts interactive and useful for small automation tasks.
- `if`, `elif`, and `else` allow scripts to make decisions based on input, file checks, or service status.
