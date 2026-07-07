# Linux Architecture, Processes, and systemd

## Core Linux Components

- **Kernel**: the core of Linux. It manages CPU, memory, disks, devices, networking, and process scheduling.
- **User space**: where applications, shells, commands, services, and user programs run.
- **Shell**: the command-line interface used to interact with the system.
- **Init / systemd**: the first user-space process started by the kernel. It manages services, boot targets, dependencies, and system state.

## How Processes Work

A process is a running program. Each process has:

- a **PID**: unique process ID
- a **PPID**: parent process ID
- a **state**: what the process is currently doing
- resource usage: CPU, memory, open files, network connections

Processes are usually created when one process starts another one. For example, a shell can start `python`, `nginx`, or `docker`. The kernel schedules processes so they can share CPU time.

## Common Process States

- **Running**: currently using the CPU or ready to run.
- **Sleeping**: waiting for something, such as disk, network, or user input.
- **Stopped**: paused, often by a signal.
- **Zombie**: finished execution, but its parent process has not collected its exit status yet.
- **Uninterruptible sleep**: waiting on low-level I/O and cannot be interrupted easily.

## What systemd Does

`systemd` is the service manager used by most modern Linux distributions. It starts and supervises services such as SSH, Docker, Nginx, databases, and background workers.

It matters because DevOps engineers often need to:

- check if a service is running
- restart a failed service
- inspect service logs
- enable services at boot
- understand service dependencies

## 5 Daily Linux Commands

- `ps aux`: list running processes.
- `top`: monitor CPU and memory usage in real time.
- `systemctl status <service>`: check service health and recent logs.
- `journalctl -u <service>`: read logs for a systemd service.
- `kill <pid>`: send a signal to stop or control a process.

## DevOps Takeaway

Linux troubleshooting starts with understanding what is running, what failed, and what changed. Processes show application behavior, while `systemd` shows service health and lifecycle. Together, they help diagnose crashes, high CPU usage, memory issues, and failed startups quickly.
