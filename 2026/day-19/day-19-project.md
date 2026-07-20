# Day 19 - Shell Scripting Project: Log Rotation, Backup & Crontab

## Objectif
Créer des scripts de maintenance shell pour la rotation des logs, les sauvegardes, et l’automatisation avec cron.

## Scripts créés

### 1. `log_rotate.sh`
```bash
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
```
**Sortie testée :**
```text
Compressed files: 2
Deleted archives: 0
```

### 2. `backup.sh`
```bash
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
```
**Sortie testée :**
```text
Archive created: backup-2026-07-20.tar.gz
Size: 4.0K
```

### 3. `health_check.sh`
```bash
#!/bin/bash
set -euo pipefail

echo "Health Check: $(date)"
echo "Disk usage:"
df -h | head -n 6
echo "Memory usage:"
free -h | head -n 3
```

### 4. `maintenance.sh`
```bash
#!/bin/bash
set -euo pipefail

LOGFILE="/var/log/maintenance.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOGFILE"
}

run_log_rotation() {
  local log_dir="/tmp/day19-logs"
  log "Running log rotation on $log_dir"
  bash "$SCRIPT_DIR/log_rotate.sh" "$log_dir" | sed "s/^/$(date '+%Y-%m-%d %H:%M:%S') - /" | tee -a "$LOGFILE"
}

run_backup() {
  local src_dir="/tmp/day19-source"
  local dest_dir="/tmp/day19-backups"
  log "Running backup from $src_dir to $dest_dir"
  bash "$SCRIPT_DIR/backup.sh" "$src_dir" "$dest_dir" | sed "s/^/$(date '+%Y-%m-%d %H:%M:%S') - /" | tee -a "$LOGFILE"
}

main() {
  log "Starting maintenance"
  run_log_rotation
  run_backup
  log "Maintenance complete"
}

main
```
**Sortie testée dans `/var/log/maintenance.log` :**
```text
2026-07-20 19:19:06 - Starting maintenance
2026-07-20 19:19:06 - Running log rotation on /tmp/day19-logs
2026-07-20 19:19:06 - Compressed files: 0
2026-07-20 19:19:06 - Deleted archives: 0
2026-07-20 19:19:06 - Running backup from /tmp/day19-source to /tmp/day19-backups
2026-07-20 19:19:06 - Archive created: backup-2026-07-20.tar.gz
2026-07-20 19:19:06 - Size: 4.0K
2026-07-20 19:19:06 - Maintenance complete
```

## Cron entries
- Daily log rotation at 2 AM :
```cron
0 2 * * * /workspaces/90DaysOfDevOps/2026/day-19/log_rotate.sh /tmp/day19-logs
```
- Weekly backup on Sunday at 3 AM :
```cron
0 3 * * 0 /workspaces/90DaysOfDevOps/2026/day-19/backup.sh /tmp/day19-source /tmp/day19-backups
```
- Health check every 5 minutes :
```cron
*/5 * * * * /workspaces/90DaysOfDevOps/2026/day-19/health_check.sh
```
- Daily maintenance at 1 AM :
```cron
0 1 * * * /workspaces/90DaysOfDevOps/2026/day-19/maintenance.sh
```

## Crontab actuel
```cron
30 2 * * * /workspaces/90DaysOfDevOps/2023/day05/backup.sh
```

## Ce que j'ai appris
1. Les scripts de maintenance doivent toujours vérifier l'existence des répertoires sources avant de démarrer.
2. La rotation des logs combine compression et suppression d'anciens fichiers pour éviter le remplissage du disque.
3. Le journaling des scripts de maintenance facilite le suivi et le debug lorsque les tâches cron s'exécutent en arrière-plan.
