# Day 07 - Linux File System Hierarchy and Scenarios

Environment note: I am working locally on Windows. WSL is installed, but no Linux distribution is configured, so the commands below should be run in Ubuntu, WSL, a VM, or GitHub Codespaces for real output. The troubleshooting flow is still documented as it would be used on a Linux server.

## Part 1: File System Hierarchy

| Directory | What it contains | Example items to look for | I would use this when... |
|---|---|---|---|
| `/` | Root of the entire Linux filesystem. Every file, device, config, and mounted disk starts from here. | `home`, `etc`, `var` | I need to understand where a file or service path belongs. |
| `/home` | Regular users' home directories. User files, shell configs, SSH keys, and project folders often live here. | user folders, `.bashrc` | I troubleshoot user-specific scripts or SSH configuration. |
| `/root` | Home directory for the root user. It is separate from `/home` and usually restricted. | root shell files, admin scripts | I need to check files created by root or admin automation. |
| `/etc` | System-wide configuration files for services, packages, networking, users, and the OS. | `hostname`, `hosts`, `ssh` | I need to inspect or edit service/system configuration. |
| `/var/log` | Log files written by the OS and services. Very important for incident investigation. | `syslog`, `auth.log`, service logs | I need to understand why something failed. |
| `/tmp` | Temporary files. Usually writable by many users and cleaned periodically. | app temp files, test files | I need a quick scratch location for troubleshooting. |
| `/bin` | Essential command binaries needed for basic system use. | `ls`, `cat`, `cp` | I need core commands even in minimal environments. |
| `/usr/bin` | Most user-level command binaries installed by the OS or packages. | `python3`, `curl`, `grep` | I need to find where a command is installed. |
| `/opt` | Optional or third-party applications, often manually installed. | vendor app folders | I troubleshoot software installed outside package defaults. |

### Hands-on Commands

```bash
ls -l /
ls -l /home
ls -l /etc
ls -l /var/log
ls -l /tmp
ls -l /bin
ls -l /usr/bin
ls -l /opt
```

Useful checks:

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
cat /etc/hostname
ls -la ~
```

What I expect to learn from these commands:

- `/var/log` shows which services are generating the largest logs.
- `/etc/hostname` identifies the machine name.
- `ls -la ~` shows user config files such as `.bashrc`, `.profile`, `.ssh`, or project folders.

## Part 2: Scenario Practice

### Scenario 1: Service Not Starting

Problem: A web application service called `myapp` failed to start after a server reboot.

Step 1:
```bash
systemctl status myapp
```
Why: Check whether the service is active, failed, disabled, or missing.

Step 2:
```bash
journalctl -u myapp -n 50 --no-pager
```
Why: Read the last service logs to find the error message.

Step 3:
```bash
systemctl is-enabled myapp
```
Why: Confirm whether the service is configured to start automatically on boot.

Step 4:
```bash
systemctl cat myapp
```
Why: Inspect the unit file to verify the command, working directory, user, and dependencies.

Step 5:
```bash
systemctl restart myapp
```
Why: Retry the service after checking logs/config and confirm whether the failure still happens.

### Scenario 2: High CPU Usage

Problem: The application server is slow and I need to identify the process using high CPU.

Step 1:
```bash
top
```
Why: Get a live view of CPU and memory usage. Press `q` to quit.

Step 2:
```bash
ps aux --sort=-%cpu | head -10
```
Why: List the top CPU-consuming processes in a quick snapshot.

Step 3:
```bash
ps -p <pid> -o pid,ppid,pcpu,pmem,comm,args
```
Why: Inspect the specific process, its parent, resource usage, and command.

Step 4:
```bash
journalctl _PID=<pid> -n 50 --no-pager
```
Why: Check logs connected to that process if journald has entries for it.

### Scenario 3: Finding Service Logs

Problem: A developer asks where the logs are for the `docker` service managed by systemd.

Step 1:
```bash
systemctl status docker
```
Why: Confirm the service exists and check recent log lines.

Step 2:
```bash
journalctl -u docker -n 50 --no-pager
```
Why: Show the last 50 logs for the Docker service.

Step 3:
```bash
journalctl -u docker -f
```
Why: Follow Docker logs in real time while reproducing the issue.

Step 4:
```bash
journalctl -u docker --since "1 hour ago" --no-pager
```
Why: Limit logs to a recent time window during investigation.

### Scenario 4: File Permissions Issue

Problem: `/home/user/backup.sh` is not executing and returns `Permission denied`.

Step 1:
```bash
ls -l /home/user/backup.sh
```
Why: Check if the script has execute permission.

Step 2:
```bash
chmod +x /home/user/backup.sh
```
Why: Add execute permission for the script.

Step 3:
```bash
ls -l /home/user/backup.sh
```
Why: Verify that an `x` permission is now visible.

Step 4:
```bash
/home/user/backup.sh
```
Why: Run the script using its full path to confirm the fix.

## Key Takeaways

- Config usually lives in `/etc`, logs in `/var/log`, user files in `/home`, and temporary work in `/tmp`.
- Start troubleshooting with status, logs, and resource usage before changing anything.
- `systemctl`, `journalctl`, `ps`, `top`, `ls -l`, and `chmod` are core tools for real Linux operations.
