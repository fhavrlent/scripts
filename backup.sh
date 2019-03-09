#!/bin/sh

REPOSITORY=~/Backup

/usr/local/bin/borg create -v --stats                          \
    $REPOSITORY::'{hostname}-{now:%Y-%m-%d-%HH-%MM-%SS}'    \
    ~/.bash_profile \
    ~/.bashrc \
    ~/.ssh \
    ~/.vscode \
    ~/.zshrc \
    ~/Documents \
    ~/Pictures \
    ~/Movies \
    ~/Music \
    ~/repos \
    --exclude */node_modules
    
/usr/local/bin/borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
    --keep-hourly=24 --keep-daily=7 --keep-weekly=4 --keep-monthly=6

rclone copy $REPOSITORY gbackup: