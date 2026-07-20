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
