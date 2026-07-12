# Day 09 - Linux User and Group Management

## Environment

- Runtime: Docker Desktop on Windows
- Linux container: `devops-ubuntu`
- User running commands: `root` inside the container

## Users and Groups Created

Users:

- `tokyo`
- `berlin`
- `professor`
- `nairobi`

Groups:

- `developers`
- `admins`
- `project-team`

## Group Assignments

| User | Groups |
|---|---|
| `tokyo` | `tokyo`, `developers`, `project-team` |
| `berlin` | `berlin`, `developers`, `admins` |
| `professor` | `professor`, `admins` |
| `nairobi` | `nairobi`, `project-team` |

Verification:

```text
tokyo : tokyo developers project-team
berlin : berlin developers admins
professor : professor admins
nairobi : nairobi project-team
```

## Directories Created

| Directory | Group Owner | Permissions | Purpose |
|---|---|---|---|
| `/opt/dev-project` | `developers` | `775` | Shared workspace for `tokyo` and `berlin` |
| `/opt/team-workspace` | `project-team` | `775` | Shared workspace for `nairobi` and `tokyo` |

Verification:

```text
drwxrwxr-x 2 root developers   4096 Jul 12 03:01 /opt/dev-project
drwxrwxr-x 2 root project-team 4096 Jul 12 03:01 /opt/team-workspace
```

## Files Created During Access Test

```text
/opt/dev-project:
- berlin.txt created by berlin
- tokyo.txt created by tokyo

/opt/team-workspace:
- nairobi.txt created by nairobi
```

Verification:

```text
total 0
-rw-r--r-- 1 berlin berlin 0 Jul 12 03:01 berlin.txt
-rw-r--r-- 1 tokyo  tokyo  0 Jul 12 03:01 tokyo.txt

total 0
-rw-r--r-- 1 nairobi nairobi 0 Jul 12 03:01 nairobi.txt
```

## Commands Used

Create users with home directories:

```bash
useradd -m -s /bin/bash tokyo
useradd -m -s /bin/bash berlin
useradd -m -s /bin/bash professor
useradd -m -s /bin/bash nairobi
```

Set passwords:

```bash
printf "tokyo:DevOps123!\nberlin:DevOps123!\nprofessor:DevOps123!\nnairobi:DevOps123!\n" | chpasswd
```

Create groups:

```bash
groupadd developers
groupadd admins
groupadd project-team
```

Assign users to groups:

```bash
usermod -aG developers tokyo
usermod -aG developers,admins berlin
usermod -aG admins professor
usermod -aG project-team nairobi
usermod -aG project-team tokyo
```

Create shared directories:

```bash
mkdir -p /opt/dev-project /opt/team-workspace
chgrp developers /opt/dev-project
chmod 775 /opt/dev-project
chgrp project-team /opt/team-workspace
chmod 775 /opt/team-workspace
```

Test file creation as specific users:

```bash
runuser -u tokyo -- touch /opt/dev-project/tokyo.txt
runuser -u berlin -- touch /opt/dev-project/berlin.txt
runuser -u nairobi -- touch /opt/team-workspace/nairobi.txt
```

Verify users, groups, permissions, and files:

```bash
getent passwd tokyo berlin professor nairobi
ls -ld /home/tokyo /home/berlin /home/professor /home/nairobi
getent group developers admins project-team
groups tokyo
groups berlin
groups professor
groups nairobi
ls -ld /opt/dev-project /opt/team-workspace
ls -l /opt/dev-project /opt/team-workspace
```

## What I Learned

- `useradd -m` creates a user and its home directory.
- `usermod -aG` adds a user to supplementary groups without removing existing memberships.
- Shared Linux workspaces depend on both group ownership with `chgrp` and write permissions with `chmod`.
- `runuser -u <user> -- <command>` is useful for testing access as another user inside a container.
