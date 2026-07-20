#!/bin/bash
check_disk() {
  df -h /
}
check_memory() {
  free -h
}
echo "Disk usage for /:"
check_disk

echo "\nMemory usage:"
check_memory
