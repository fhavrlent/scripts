#!/bin/sh

REPOSITORY=~/Backup

borg create -v --stats                          \
    $REPOSITORY::'{hostname}-{now:%Y-%m-%d-%HH-%MM}'    \
    ~/.bash_profile \
    ~/.bashrc \
    ~/.ssh \
    ~/.vscode \
    ~/.zshrc \
    ~/Documents \
    ~/Movies \
    ~/Pictures \
    ~/repos \
    ~/Disk\ Google \
    --exclude */node_modules
    
borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
    --keep-hourly=24 --keep-daily=7 --keep-weekly=4 --keep-monthly=6