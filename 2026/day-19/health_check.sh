#!/bin/bash
set -euo pipefail

echo "Health Check: $(date)"
echo "Disk usage:"
df -h | head -n 6
echo "Memory usage:"
free -h | head -n 3
