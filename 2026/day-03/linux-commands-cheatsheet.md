# Linux Commands Cheat Sheet

## File System Navigation

- `pwd`: show the current directory.
- `ls -la`: list files, including hidden files and permissions.
- `cd /path/to/dir`: move to another directory.
- `tree -L 2`: display a directory structure up to 2 levels deep.
- `find . -name "*.log"`: search for files by name or pattern.

## File Reading and Search

- `cat file.txt`: print a small file to the terminal.
- `less file.txt`: read a large file page by page.
- `head -n 20 file.txt`: show the first 20 lines.
- `tail -n 50 file.txt`: show the last 50 lines.
- `tail -f app.log`: follow a log file in real time.
- `grep "ERROR" app.log`: search for matching text in a file.
- `grep -R "TODO" .`: search recursively inside files.

## File Operations and Permissions

- `cp source.txt backup.txt`: copy a file.
- `mv old.txt new.txt`: move or rename a file.
- `mkdir -p logs/archive`: create directories, including parents.
- `rm file.txt`: remove a file.
- `chmod +x script.sh`: make a script executable.
- `chown user:group file.txt`: change file owner and group.

## Process Management

- `ps aux`: list all running processes.
- `top`: monitor CPU and memory usage live.
- `htop`: interactive process viewer when installed.
- `pgrep nginx`: find process IDs by name.
- `kill <pid>`: send a signal to stop a process.
- `kill -9 <pid>`: force kill a stuck process.

## Services and Logs

- `systemctl status nginx`: check the status of a service.
- `systemctl restart nginx`: restart a service.
- `systemctl enable nginx`: start a service automatically on boot.
- `journalctl -u nginx`: view logs for a systemd service.
- `journalctl -u nginx -f`: follow service logs in real time.

## Disk and Resource Checks

- `df -h`: check disk space by filesystem.
- `du -sh *`: show size of files and directories in the current folder.
- `free -h`: check memory usage.
- `uptime`: show load average and system uptime.
- `whoami`: show the current user.

## Networking Troubleshooting

- `ping google.com`: test basic network connectivity.
- `ip addr`: show network interfaces and IP addresses.
- `curl -I https://example.com`: check HTTP response headers.
- `dig example.com`: inspect DNS resolution.
- `ss -tulnp`: show listening TCP/UDP ports and related processes.

## DevOps Takeaway

Most production troubleshooting starts with a few questions: what is running, what changed, what failed, and whether the service can communicate over the network. These commands help inspect files, logs, processes, resources, and connectivity quickly from the terminal.
