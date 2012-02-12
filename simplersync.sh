#!/bin/sh
echo Subject: Backup Backup Started on `date "+%m/%d/%y %l:%M:%S %p"` > /mnt/disk/backuprsync.log
rsync -av --stats rsync://192.168.1.111/backup/ /mnt/disk/backup/ >> /mnt/disk/backuprsync.log
echo END: Backup Backup Complete on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/disk/backuprsync.log
cat /mnt/disk/backuprsync.log | ssmtp someaddress@gmail.com
