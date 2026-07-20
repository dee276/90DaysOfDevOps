# Day 17 - Shell Scripting: Loops, Arguments & Error Handling

## Objectif
Créer et tester plusieurs scripts shell utilisant des boucles, des arguments, des installations de paquets et un traitement d'erreurs de base.

## Scripts créés

### 1. `for_loop.sh`
```bash
#!/bin/bash
fruits=(apple banana cherry date elderberry)
for fruit in "${fruits[@]}"; do
  echo "Fruit: $fruit"
done
```
**Sortie :**
```text
Fruit: apple
Fruit: banana
Fruit: cherry
Fruit: date
Fruit: elderberry
```

### 2. `count.sh`
```bash
#!/bin/bash
for i in {1..10}; do
  echo "Count: $i"
done
```
**Sortie :**
```text
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
Count: 6
Count: 7
Count: 8
Count: 9
Count: 10
```

### 3. `countdown.sh`
```bash
#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./countdown.sh <number>"
  exit 1
fi
n=$1
while [ "$n" -ge 0 ]; do
  echo "Countdown: $n"
  n=$((n - 1))
done
echo "Done!"
```
**Sortie avec `./countdown.sh 3` :**
```text
Countdown: 3
Countdown: 2
Countdown: 1
Countdown: 0
Done!
```

### 4. `greet.sh`
```bash
#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./greet.sh <name>"
  exit 1
fi
echo "Hello, $1!"
```
**Sortie avec `./greet.sh Test` :**
```text
Hello, Test!
```

### 5. `args_demo.sh`
```bash
#!/bin/bash
echo "Script name: $0"
echo "Argument count: $#"
echo "All arguments: $@"
```
**Sortie avec `./args_demo.sh one two three` :**
```text
Script name: ./args_demo.sh
Argument count: 3
All arguments: one two three
```

### 6. `install_packages.sh`
```bash
#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi
packages=(nginx curl wget)
for pkg in "${packages[@]}"; do
  if dpkg -s "$pkg" &> /dev/null; then
    echo "$pkg is already installed"
  else
    echo "Installing $pkg..."
    apt install -y "$pkg"
  fi
done
```
**Sortie :**
```text
Installing nginx...
# installation de nginx...
curl is already installed
wget is already installed
```

### 7. `safe_script.sh`
```bash
#!/bin/bash
set -e
mkdir /tmp/devops-test || echo "Directory already exists"
cd /tmp/devops-test || { echo "Cannot enter /tmp/devops-test"; exit 1; }
touch example.txt
echo "Created example.txt in /tmp/devops-test"
```
**Sortie :**
```text
Created example.txt in /tmp/devops-test
```

## Vérification finale
Le fichier `/tmp/devops-test/example.txt` a bien été créé avec les droits root.

## Ce que j'ai appris
1. Les boucles `for` et `while` permettent de traiter des listes et des conditions de manière simple et lisible dans Bash.
2. Les arguments positionnels (`$1`, `$#`, `$@`, `$0`) sont essentiels pour rendre un script réutilisable et paramétrable.
3. Le contrôle des erreurs avec `set -e` et la vérification de l'environnement d'exécution (root) rendent les scripts plus sûrs et plus robustes.
