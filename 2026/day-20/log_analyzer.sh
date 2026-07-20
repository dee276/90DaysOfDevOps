#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <log_file>"
  exit 1
fi

log_file="$1"
if [ ! -f "$log_file" ]; then
  echo "Error: File '$log_file' does not exist"
  exit 1
fi

report_date=$(date +%Y-%m-%d)
log_name=$(basename "$log_file")
report_file="log_report_${report_date}.txt"
archive_dir="archive"

total_lines=$(wc -l < "$log_file" | tr -d '[:space:]')
error_count=$(grep -E 'ERROR|Failed' "$log_file" | wc -l | tr -d '[:space:]')
critical_events=$(grep -n 'CRITICAL' "$log_file" || true)

# Extract top 5 error messages from ERROR lines
error_messages=$(grep 'ERROR' "$log_file" || true)
top_errors=$(printf '%s\n' "$error_messages" | sed -E 's/^.*\[ERROR\] ?//' | sort | uniq -c | sort -rn | head -n 5 | sed -E 's/^ +//')

cat > "$report_file" <<REPORT
Log Analysis Report - $report_date

Log file: $log_name
Total lines processed: $total_lines
Total error count (ERROR or Failed): $error_count

--- Top 5 Error Messages ---
$top_errors

--- Critical Events ---
$critical_events
REPORT

echo "Generated report: $report_file"

# Optional archive
mkdir -p "$archive_dir"
archive_path="$archive_dir/$log_name"
if [ -f "$archive_path" ]; then
  archive_path="${archive_dir}/${log_name%.*}-$(date +%Y%m%d%H%M%S).${log_name##*.}"
fi
mv "$log_file" "$archive_path"
echo "Archived processed log to: $archive_path"
