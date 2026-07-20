#!/bin/bash
set -euo pipefail

print_header() {
  echo "\n===== $1 ====="
}

print_host_info() {
  print_header "Host and OS Info"
  echo "Hostname: $(hostname)"
  cat /etc/os-release | grep -E '^NAME=|^VERSION='
}

print_uptime() {
  print_header "Uptime"
  uptime -p
}

print_disk_usage() {
  print_header "Top 5 Disk Usage"
  df -h --output=source,fstype,size,used,avail,pcent,target | sort -k5 -rn | head -n 6
}

print_memory_usage() {
  print_header "Memory Usage"
  free -h
}

print_top_cpu() {
  print_header "Top 5 CPU Processes"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

main() {
  print_host_info
  print_uptime
  print_disk_usage
  print_memory_usage
  print_top_cpu
}

main
