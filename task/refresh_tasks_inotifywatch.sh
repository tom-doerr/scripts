#! /bin/bash

clear
task

inotifywait -r -q -m -e close_write ~/Nextcloud/sonstiges/task/backlog.data ~/git/dotfiles/taskrc |
while read -r filename event; do
    clear
    task # or "./$filename"
done
