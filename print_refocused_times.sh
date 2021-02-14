#!/bin/bash

STARTPOINTS="15min 1hour 4hours"
REFRESH_INTERVAL=300
LOG_DIR="/home/tom/git/refocused_timestamps_log"

print_times_refocused() {
    start_time_ago=$1
    awk '$0>'$(date -d "$start_time_ago ago" +%s) log | wc -l
}

cd $LOG_DIR

while true
do
    git pull
    clear
    printf '\n  '
    for e in $STARTPOINTS
    do
        printf "$(print_times_refocused $e)  "
    done
    sleep $REFRESH_INTERVAL
done



