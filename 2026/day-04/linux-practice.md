# Day 04 - Linux Practice: Processes and Services

Date: 2026-07-08
Environment: Ubuntu container on Linux
User: codespace

## 1. Process checks

### Command 1
```bash
ps -ef | head -n 8
```

Output:
```text
UID          PID    PPID  C STIME TTY          TIME CMD
codespa+       1       0  0 13:41 ?        00:00:00 /sbin/docker-init -- /bin/sh
codespa+       7       1  0 13:41 ?        00:00:00 /bin/sh -c echo Container started ...
root          34       1  0 13:41 ?        00:00:00 sshd: /usr/sbin/sshd [listener] 0 of 10-100 startups
root          57       1  0 13:41 ?        00:00:00 dockerd --dns 168.63.129.16
root         126      57  0 13:41 ?        00:00:00 containerd --config /var/run/docker/containerd/containerd.toml
codespa+     166       0  0 13:41 ?        00:00:00 /bin/sh
root         198       0  0 13:41 ?        00:00:00 /bin/sh
```

### Command 2
```bash
pgrep -af sshd
```

Output:
```text
34 sshd: /usr/sbin/sshd [listener] 0 of 10-100 startups
```

## 2. Service checks

### Command 3
```bash
service ssh status
```

Output:
```text
* sshd is running
```

### Command 4
```bash
service docker status
```

Output:
```text
docker: unrecognized service
```

## 3. Log checks

### Command 5
```bash
tail -n 20 /var/log/syslog
```

Output:
```text
syslog not available
```

### Command 6
```bash
journalctl -u ssh --no-pager | tail -n 20
```

Output:
```text
No journal files were found.
-- No entries --
```

## 4. Mini troubleshooting steps

- I verified that the SSH daemon process is running.
- I confirmed that the container does not expose a full `systemd` environment, so `service` was used instead of `systemctl`.
- I also checked Docker-related service status and found that the service is not available in this environment.
