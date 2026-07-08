# Day 05 - Linux Troubleshooting Runbook

## Target service / process
- Target: SSH daemon (`sshd`)
- Reason: It is a common service to inspect for availability, listening ports, and basic health.

## Snapshot: Environment basics
### Command 1
```bash
uname -a
```
Observed: The host is an Ubuntu 24.04-based container running a Linux kernel with the expected containerized environment.

### Command 2
```bash
cat /etc/os-release
```
Observed: The OS is Ubuntu 24.04.4 LTS, which is suitable for basic Linux troubleshooting and service checks.

## Snapshot: Filesystem sanity
### Command 3
```bash
mkdir -p /tmp/runbook-demo && cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
```
Observed: A temporary folder and copied file were created successfully, confirming basic filesystem write access.

## Snapshot: CPU & Memory
### Command 4
```bash
ps -o pid,pcpu,pmem,comm -p 1
```
Observed: PID 1 is using minimal CPU and memory, which is expected for the container init process.

### Command 5
```bash
free -h
```
Observed: Memory usage is moderate, with about 5.5 GiB available, so the container is not under immediate memory pressure.

## Snapshot: Disk & IO
### Command 6
```bash
df -h
```
Observed: Disk usage is healthy overall, with available space on the main filesystem.

### Command 7
```bash
du -sh /var/log
```
Observed: The log directory is small enough to inspect quickly, though access to some nested log files was restricted by permissions.

## Snapshot: Network
### Command 8
```bash
ss -tulpn | head -n 20
```
Observed: SSH is listening on port 2222, and several local services are listening on localhost as expected in this environment.

### Command 9
```bash
curl -I https://github.com | head -n 10
```
Observed: The HTTP check returned a 200 response, showing outbound network access is working.

## Logs reviewed
### Command 10
```bash
journalctl -u ssh -n 20 --no-pager
```
Observed: No journal entries were available for the SSH service in this container.

### Command 11
```bash
tail -n 20 /var/log/auth.log
```
Observed: No readable authentication log was available in this environment.

## Quick findings
- The host is running normally with sufficient memory and disk space.
- SSH is listening and the network path to an external HTTPS endpoint is working.
- Log visibility is limited in this container, so troubleshooting would rely more on process and port checks than journal logs.

## If this worsens
1. Increase log verbosity and inspect service-specific logs more closely.
2. Check whether the process is still running and whether the port is bound after a restart.
3. Capture a fresh process and network snapshot, then compare it to the baseline.
