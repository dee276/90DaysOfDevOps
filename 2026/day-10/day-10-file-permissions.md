# Day 10 - File Permissions and File Operations

## Environment

- Runtime: Docker Desktop on Windows
- Linux container: `devops-ubuntu`
- Working directory inside container: `/tmp/day10-permissions`

Note: In a real terminal session, `script.sh` can be created with `vim script.sh`. Because this was executed non-interactively through Docker, I created the same file content with `echo`.

## Files Created

```bash
touch devops.txt
echo 'Linux file permissions practice' > notes.txt
echo 'Line 2' >> notes.txt
echo 'Line 3' >> notes.txt
echo 'echo Hello DevOps' > script.sh
```

Initial permissions:

```text
-rw-r--r-- 1 root root  0 Jul 12 03:13 devops.txt
-rw-r--r-- 1 root root 46 Jul 12 03:13 notes.txt
-rw-r--r-- 1 root root 18 Jul 12 03:13 script.sh
```

Meaning:

- Owner can read and write all three files.
- Group can read all three files.
- Others can read all three files.
- Nobody can execute `script.sh` yet because it does not have `x` permission.

## Read Operations

Read `notes.txt`:

```bash
cat notes.txt
```

Output:

```text
Linux file permissions practice
Line 2
Line 3
```

Read `/etc/passwd`:

```bash
head -n 5 /etc/passwd
tail -n 5 /etc/passwd
```

Example output:

```text
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
```

```text
ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
tokyo:x:1001:1001::/home/tokyo:/bin/bash
berlin:x:1002:1002::/home/berlin:/bin/bash
professor:x:1003:1003::/home/professor:/bin/bash
nairobi:x:1004:1004::/home/nairobi:/bin/bash
```

View `script.sh` in Vim read-only mode:

```bash
vim -R script.sh
```

## Permission Changes

### 1. Try executing before adding execute permission

```bash
./script.sh
```

Result:

```text
bash: line 1: ./script.sh: Permission denied
```

### 2. Make `script.sh` executable

```bash
chmod +x script.sh
./script.sh
```

Output:

```text
Hello DevOps
```

After:

```text
-rwxr-xr-x 1 root root 18 Jul 12 03:13 script.sh
```

### 3. Set `devops.txt` to read-only

```bash
chmod a-w devops.txt
```

After:

```text
-r--r--r-- 1 root root 0 Jul 12 03:13 devops.txt
```

Write test as a non-root user:

```bash
runuser -u tokyo -- sh -c 'echo test >> /tmp/day10-permissions/devops.txt'
```

Result:

```text
sh: 1: cannot create /tmp/day10-permissions/devops.txt: Permission denied
```

### 4. Set `notes.txt` to `640`

```bash
chmod 640 notes.txt
```

After:

```text
-rw-r----- 1 root root 46 Jul 12 03:13 notes.txt
```

Meaning:

- Owner: read and write
- Group: read only
- Others: no access

### 5. Create `project/` with `755`

```bash
mkdir project
chmod 755 project
```

After:

```text
drwxr-xr-x 2 root root 4096 Jul 12 03:13 project
```

Meaning:

- Owner can read, write, and enter the directory.
- Group and others can read and enter, but cannot create files inside it.

## Commands Used

```bash
touch devops.txt
cat notes.txt
head -n 5 /etc/passwd
tail -n 5 /etc/passwd
vim -R script.sh
ls -l devops.txt notes.txt script.sh
chmod +x script.sh
chmod a-w devops.txt
chmod 640 notes.txt
mkdir project
chmod 755 project
runuser -u tokyo -- sh -c 'echo test >> /tmp/day10-permissions/devops.txt'
```

## What I Learned

- Linux permissions are split between owner, group, and others.
- A shell script needs execute permission before it can run with `./script.sh`.
- Numeric permissions like `640` and `755` are compact ways to express read, write, and execute access.
- Testing with a non-root user is important because root can bypass many permission restrictions.
