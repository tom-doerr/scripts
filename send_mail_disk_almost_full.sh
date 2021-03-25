#!/bin/bash


FREE_DISK_SPACE_THRESHOLD=100000000
RECEIVER_EMAIL_ADDRESS="tom.doerr@tum.de"

get_free_disk_space() {
    df_options=$@
    df $df_options | grep '/$' | awk '{print $4}' 
}

while true
do
    free_disk_space=$(get_free_disk_space)
    echo "free_disk_space: " "$free_disk_space"
    if (( $free_disk_space < $FREE_DISK_SPACE_THRESHOLD ))
    then
        echo "" | neomutt -s "Only $(get_free_disk_space -h) free on Desktop." $RECEIVER_EMAIL_ADDRESS
        sleep 12h
    fi
    sleep 60
done
