#!/bin/bash
backup_node=192.168.31.220
backup_target=/home/pi/backup/
# Verify backup node
ping -c 4 $backup_node &> /dev/null
[ $? -eq 1 ] && exit 1
# backup Dev folder
rsync -avz --delete --exclude 'go/pkg' --exclude '.terraform' --exclude '.git' -e ssh ~/Dev pi@${backup_node}:${backup_target}
# backup Document
rsync -avz --delete --exclude 'cases' --exclude 'go/pkg' --exclude '.terraform' --exclude '.git' -e ssh ~/Documents pi@${backup_node}:${backup_target}
