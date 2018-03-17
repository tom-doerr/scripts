#! /bin/bash

filename=~/Nextcloud/sonstiges/task/backlog.data

clear
task

inotifywait -r -q -m -e close_write $filename |
while read -r filename event; do
    clear
    task # or "./$filename"
done
