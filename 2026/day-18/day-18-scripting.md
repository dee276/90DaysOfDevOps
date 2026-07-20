# Day 18 - Shell Scripting: Functions & Intermediate Concepts

## Objectif
Créer des scripts Bash réutilisables avec des fonctions, des variables locales, et une meilleure sécurité via `set -euo pipefail`.

## Scripts créés

### 1. `functions.sh`
```bash
#!/bin/bash
greet() {
  echo "Hello, $1!"
}
add() {
  echo "$(( $1 + $2 ))"
}
greet "DevOps"
echo "Sum: $(add 5 7)"
```
**Sortie :**
```text
Hello, DevOps!
Sum: 12
```

### 2. `disk_check.sh`
```bash
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
```
**Sortie :**
```text
Disk usage for /:
Filesystem      Size  Used Avail Use% Mounted on
overlay          32G  9.7G   21G  33% /

Memory usage:
               total        used        free      shared  buff/cache   available
Mem:           7.8Gi       2.3Gi       164Mi        60Mi       5.7Gi       5.5Gi
Swap:             0B          0B          0B
```

### 3. `strict_demo.sh`
```bash
#!/bin/bash
set -euo pipefail

# undefined variable will fail
# echo "$UNDEFINED_VAR"

# failing command will stop the script
# false

# pipefail example: grep on non-existent file
# cat missing.txt | grep foo

echo "This script is running strict mode."
```
**Sortie :**
```text
This script is running strict mode.
```

### 4. `local_demo.sh`
```bash
#!/bin/bash
default_vars() {
  var="global"
}
local_vars() {
  local var="local"
  echo "Inside function: $var"
}

default_vars
local_vars

echo "Outside function: $var"
```
**Sortie :**
```text
Inside function: local
Outside function: global
```

### 5. `system_info.sh`
```bash
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
```
**Sortie :**
```text
===== Host and OS Info =====
Hostname: codespaces-71d484
NAME="Ubuntu"
VERSION="24.04.4 LTS (Noble Numbat)"

===== Uptime =====
up 10 minutes

===== Top 5 Disk Usage =====
tmpfs          tmpfs     64M     0   64M   0% /dev
shm            tmpfs     64M     0   64M   0% /dev/shm
/dev/sdb1      ext4      44G  1.8G   40G   5% /tmp
overlay        overlay   32G  9.7G   21G  33% /
/dev/loop4     ext4      32G  9.7G   21G  33% /workspaces
/dev/root      ext4      29G   24G   5.6G  81% /vscode

===== Memory Usage =====
               total        used        free      shared  buff/cache   available
Mem:           7.8Gi       2.3Gi       171Mi        60Mi       5.7Gi       5.5Gi
Swap:             0B          0B          0B

===== Top 5 CPU Processes =====
    PID COMMAND         %CPU
    611 MainThread      13.1
    580 MainThread       1.4
   1114 MainThread       0.2
   1098 MainThread       0.1
   2019 bash             0.1
```

## Explication de `set -euo pipefail`
- `set -e` → le script s'arrête immédiatement lorsqu'une commande retourne un code d'erreur non nul.
- `set -u` → le script s'arrête si une variable non définie est utilisée.
- `set -o pipefail` → si une commande dans un pipe échoue, le pipeline entier échoue.

## Ce que j'ai appris
1. Utiliser des fonctions rend un script plus lisible et réutilisable.
2. `set -euo pipefail` augmente la robustesse des scripts en détectant rapidement les erreurs.
3. Les variables locales ne polluent pas l'espace global, ce qui évite les effets de bord.
