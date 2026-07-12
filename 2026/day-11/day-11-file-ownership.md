# Day 11 - File Ownership Challenge

## Environment

- Runtime: Docker Desktop on Windows
- Linux container: `devops-ubuntu`
- Working directory inside container: `/tmp/day11-ownership`
- User running ownership commands: `root`

## Ownership Basics

Linux files have both an **owner** and a **group**.

Format:

```text
-rw-r--r-- 1 owner group size date filename
```

- The **owner** is the user account that owns the file.
- The **group** is the group assigned to the file, which helps manage access for multiple users.

Home directory ownership sample:

```text
drwxr-x--- 2 berlin    berlin    4096 Jul 12 03:00 berlin
drwxr-x--- 2 nairobi   nairobi   4096 Jul 12 03:00 nairobi
drwxr-x--- 2 professor professor 4096 Jul 12 03:00 professor
drwxr-x--- 2 tokyo     tokyo     4096 Jul 12 03:00 tokyo
```

## Files and Directories Created

- `devops-file.txt`
- `team-notes.txt`
- `project-config.yaml`
- `app-logs/`
- `heist-project/`
- `heist-project/vault/gold.txt`
- `heist-project/plans/strategy.conf`
- `bank-heist/access-codes.txt`
- `bank-heist/blueprints.pdf`
- `bank-heist/escape-plan.txt`

Groups created or reused:

- `heist-team`
- `planners`
- `vault-team`
- `tech-team`

Users reused from Day 09:

- `tokyo`
- `berlin`
- `professor`
- `nairobi`

## Ownership Changes

### Task 2: Basic `chown`

Initial owner:

```text
-rw-r--r-- 1 root root 0 Jul 12 03:23 devops-file.txt
```

After changing owner to `tokyo`:

```text
-rw-r--r-- 1 tokyo root 0 Jul 12 03:23 devops-file.txt
```

After changing owner to `berlin`:

```text
-rw-r--r-- 1 berlin root 0 Jul 12 03:23 devops-file.txt
```

### Task 3: Basic `chgrp`

Initial group:

```text
-rw-r--r-- 1 root root 0 Jul 12 03:23 team-notes.txt
```

After changing group to `heist-team`:

```text
-rw-r--r-- 1 root heist-team 0 Jul 12 03:23 team-notes.txt
```

### Task 4: Combined Owner and Group Change

```text
drwxr-xr-x 2 berlin    heist-team 4096 Jul 12 03:23 app-logs
-rw-r--r-- 1 professor heist-team    0 Jul 12 03:23 project-config.yaml
```

### Task 5: Recursive Ownership

`heist-project/` and everything inside it was changed to:

- owner: `professor`
- group: `planners`

Verification:

```text
heist-project:
total 8
drwxr-xr-x 2 professor planners 4096 Jul 12 03:23 plans
drwxr-xr-x 2 professor planners 4096 Jul 12 03:23 vault

heist-project/plans:
total 0
-rw-r--r-- 1 professor planners 0 Jul 12 03:23 strategy.conf

heist-project/vault:
total 0
-rw-r--r-- 1 professor planners 0 Jul 12 03:23 gold.txt
```

### Task 6: Practice Challenge

Final ownership inside `bank-heist/`:

```text
total 0
-rw-r--r-- 1 tokyo   vault-team 0 Jul 12 03:23 access-codes.txt
-rw-r--r-- 1 berlin  tech-team  0 Jul 12 03:23 blueprints.pdf
-rw-r--r-- 1 nairobi vault-team 0 Jul 12 03:23 escape-plan.txt
```

## Commands Used

Create/reuse users and groups:

```bash
id tokyo || useradd -m -s /bin/bash tokyo
id berlin || useradd -m -s /bin/bash berlin
id professor || useradd -m -s /bin/bash professor
id nairobi || useradd -m -s /bin/bash nairobi

groupadd -f heist-team
groupadd -f planners
groupadd -f vault-team
groupadd -f tech-team
```

Task 2:

```bash
touch devops-file.txt
ls -l devops-file.txt
chown tokyo devops-file.txt
ls -l devops-file.txt
chown berlin devops-file.txt
ls -l devops-file.txt
```

Task 3:

```bash
touch team-notes.txt
ls -l team-notes.txt
chgrp heist-team team-notes.txt
ls -l team-notes.txt
```

Task 4:

```bash
touch project-config.yaml
chown professor:heist-team project-config.yaml

mkdir app-logs
chown berlin:heist-team app-logs

ls -ld project-config.yaml app-logs
```

Task 5:

```bash
mkdir -p heist-project/vault
mkdir -p heist-project/plans
touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf
chown -R professor:planners heist-project
ls -lR heist-project
```

Task 6:

```bash
mkdir bank-heist
touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt

chown tokyo:vault-team bank-heist/access-codes.txt
chown berlin:tech-team bank-heist/blueprints.pdf
chown nairobi:vault-team bank-heist/escape-plan.txt

ls -l bank-heist
```

## What I Learned

- `chown` changes file or directory ownership.
- `chgrp` changes only the group owner.
- `chown owner:group file` changes both owner and group in one command.
- `chown -R` is useful for directories because it applies ownership changes recursively.
- Ownership matters in DevOps because deployments, logs, shared directories, and CI/CD artifacts often need the correct user and group access.
