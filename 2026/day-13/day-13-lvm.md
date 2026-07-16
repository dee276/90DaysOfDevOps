# Day 13 - Linux Volume Management (LVM)

## Objectif
Créer un volume logique LVM sur un disque virtuel, le formater, le monter et l'étendre.

## Environnement
- Codespace Linux
- Disque virtuel : `/tmp/disk1.img`
- Loop device : `/dev/loop8`
- Volume group : `devops-vg`
- Logical volume : `app-data`
- Point de montage : `/mnt/app-data`

## Commandes utilisées

### 1. Préparer le disque virtuel
```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
sudo losetup -fP /tmp/disk1.img
sudo losetup -a
```
Observation : le fichier image de 1 Go a été créé et attaché à `/dev/loop8`.

### 2. Préparer LVM
```bash
sudo apt update && sudo apt install lvm2 -y
```
Observation : `lvm2` est installé et fournit les commandes LVM nécessaires.

### 3. Créer le Physical Volume
```bash
sudo pvcreate /dev/loop8
sudo pvs
```
Observation : `/dev/loop8` est devenu un PV LVM de 1 Go.

### 4. Créer le Volume Group
```bash
sudo vgcreate devops-vg /dev/loop8
sudo vgs
```
Observation : le VG `devops-vg` a été créé et dispose de 1020 MiB de capacité.

### 5. Créer le Logical Volume
```bash
sudo lvcreate -L 500M -n app-data devops-vg
sudo lvs
```
Observation : le LV `app-data` de 500 MiB a été créé avec succès.

### 6. Activer les nœuds LVM
```bash
sudo vgscan --mknodes
sudo lvchange -ay devops-vg/app-data
```
Observation : le chemin `/dev/devops-vg/app-data` a été recréé et activé.

### 7. Formater et monter
```bash
sudo mkfs.ext4 /dev/devops-vg/app-data
sudo mkdir -p /mnt/app-data
sudo mount /dev/devops-vg/app-data /mnt/app-data
```
Observation : le LV a été formaté en ext4 et monté sur `/mnt/app-data`.

### 8. Vérifier le montage
```bash
df -h /mnt/app-data
```
Observation : le volume monté avait initialement une taille de 452M, puis a été étendu.

### 9. Étendre le volume
```bash
sudo lvextend -L +200M /dev/devops-vg/app-data
sudo resize2fs /dev/devops-vg/app-data
```
Observation : le volume logique est passé de 500M à 700M et le système de fichiers a été redimensionné en ligne.

### 10. Vérifier l'extension
```bash
df -h /mnt/app-data
```
Observation : le volume monté affiche désormais 637M et 594M disponibles.

## Résultats
- PV : `/dev/loop8`
- VG : `devops-vg`
- LV : `app-data`
- Monté sur : `/mnt/app-data`
- Taille finale après extension : 700M

## Ce que j'ai appris
1. LVM fonctionne en trois étapes : Physical Volume (`pvcreate`), Volume Group (`vgcreate`), Logical Volume (`lvcreate`).
2. Dans un environnement conteneurisé, il peut être nécessaire de créer manuellement un périphérique loop (`/dev/loop8`) et de recréer les nœuds LVM avec `vgscan --mknodes`.
3. Après l'extension d'un LV, il faut toujours redimensionner le système de fichiers avec `resize2fs` pour utiliser l'espace supplémentaire.

## Remarques
- Si le device LVM n'est pas visible, `vgscan --mknodes` et `lvchange -ay` permettent de recréer les nœuds du système de fichiers.
- L'étape de formatage en ext4 doit être faite avant le montage.
