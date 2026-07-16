# Day 12 - Revision Notes

## Mindset and Plan Check

- My Day 01 goal still makes sense: become a software engineer who can build, deploy, automate, monitor, and troubleshoot production-ready systems.
- The DevOps portfolio angle is still important. Each day should leave behind a clear artifact: notes, commands, scripts, configs, logs, or deployment proof.
- I want to keep connecting Linux fundamentals to real engineering work: debugging services, checking logs, managing access, and understanding how applications run.

## Processes and Services Review

Commands I would rerun first:

```bash
ps aux --sort=-%cpu | head -10
systemctl status <service>
journalctl -u <service> -n 50 --no-pager
```

Observation from earlier practice:

- Containers may not expose a full `systemd` environment, so `service`, `ps`, logs, and port checks can be more useful there.
- For a real VM or cloud server, `systemctl status` and `journalctl -u` are usually the fastest first checks.
- For high CPU or slow apps, `top` and `ps aux --sort=-%cpu` help identify the process before changing anything.

## File Skills Review

Quick operations reinforced:

```bash
echo "new line" >> notes.txt
chmod +x script.sh
chmod 640 notes.txt
chown user:group file.txt
ls -l file.txt
mkdir -p project/logs
```

Key reminders:

- `>` overwrites; `>>` appends.
- A script needs execute permission before `./script.sh` works.
- `640` means owner can read/write, group can read, others have no access.
- `755` is common for directories that others can enter/read but not modify.
- Test permissions with a non-root user when possible because root can bypass many restrictions.

## Cheat Sheet Refresh

Five commands I would reach for first during an incident:

- `systemctl status <service>`: check service health quickly.
- `journalctl -u <service> -n 50 --no-pager`: inspect recent service logs.
- `ps aux --sort=-%cpu | head -10`: find high CPU processes.
- `df -h`: check if disk pressure is causing failures.
- `curl -I http://localhost:<port>`: verify whether an HTTP service responds.

## User and Group Sanity Check

Scenario from Days 09 and 11:

```bash
useradd -m -s /bin/bash tokyo
groupadd developers
usermod -aG developers tokyo
mkdir -p /opt/dev-project
chgrp developers /opt/dev-project
chmod 775 /opt/dev-project
groups tokyo
ls -ld /opt/dev-project
```

What this verifies:

- The user exists and has a home directory.
- The group exists.
- The user belongs to the correct group.
- The shared directory has group ownership and write permissions.

## Mini Self-Check

### 1. Which 3 commands save me the most time right now, and why?

- `ls -l`: shows permissions, owner, group, and file type immediately.
- `journalctl -u <service> -n 50 --no-pager`: gives recent service logs without digging through files.
- `ps aux --sort=-%cpu | head -10`: quickly identifies processes that may be causing performance issues.

### 2. How do I check if a service is healthy?

I would start with:

```bash
systemctl status <service>
journalctl -u <service> -n 50 --no-pager
ss -tulnp
```

If it is a web service, I would also run:

```bash
curl -I http://localhost:<port>
```

### 3. How do I safely change ownership and permissions without breaking access?

First inspect the current state:

```bash
ls -l app.conf
```

Then change ownership or permissions deliberately:

```bash
chown appuser:appgroup app.conf
chmod 640 app.conf
```

Finally verify:

```bash
ls -l app.conf
```

I should avoid broad recursive changes unless I understand the directory structure.

### 4. What will I focus on improving in the next 3 days?

- Build more confidence with Linux networking commands.
- Practice reading logs faster and identifying the important error line.
- Continue connecting every command to a real DevOps use case instead of memorizing commands in isolation.

## Key Takeaways

- Linux troubleshooting is mostly a flow: status, logs, processes, resources, permissions, then network.
- Permissions and ownership are not just theory; they directly affect deployments, scripts, logs, and shared workspaces.
- The strongest habit is to verify before and after every change.
