#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <log_directory>"
  exit 1
fi

log_dir="$1"
if [ ! -d "$log_dir" ]; then
  echo "Directory $log_dir does not exist"
  exit 1
fi

compressed=0
deleted=0

while IFS= read -r -d '' file; do
  gzip "$file" && compressed=$((compressed+1))
done < <(find "$log_dir" -maxdepth 1 -type f -name '*.log' -mtime +7 -print0)

while IFS= read -r -d '' file; do
  rm -f "$file" && deleted=$((deleted+1))
done < <(find "$log_dir" -maxdepth 1 -type f -name '*.gz' -mtime +30 -print0)

echo "Compressed files: $compressed"
echo "Deleted archives: $deleted"
