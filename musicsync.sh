#!/bin/bash
export RSYNC_PASSWORD=trooper
rsync -rtvz --delete sync@192.168.1.22::music/ /mnt/sda/m/ 
