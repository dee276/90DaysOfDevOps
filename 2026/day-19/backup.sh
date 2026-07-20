#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source_directory> <backup_destination>"
  exit 1
fi

src_dir="$1"
dest_dir="$2"

if [ ! -d "$src_dir" ]; then
  echo "Source directory $src_dir does not exist"
  exit 1
fi

mkdir -p "$dest_dir"

date_stamp=$(date +%Y-%m-%d)
archive_name="backup-${date_stamp}.tar.gz"
archive_path="$dest_dir/$archive_name"

tar -czf "$archive_path" -C "$src_dir" .

if [ ! -f "$archive_path" ]; then
  echo "Backup archive failed to create"
  exit 1
fi

size=$(du -h "$archive_path" | cut -f1)

echo "Archive created: $archive_name"
echo "Size: $size"

find "$dest_dir" -maxdepth 1 -type f -name 'backup-*.tar.gz' -mtime +14 -print0 | while IFS= read -r -d '' oldfile; do
  rm -f "$oldfile"
  echo "Deleted old backup: $oldfile"
done
