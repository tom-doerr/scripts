#!/bin/bash

while true; do
    tw_output=$(timew)
    tracking_line=$(printf "$tw_output" | awk 'NR==1')  
    if [[ $tracking_line == *" video "* ]] && [[ $(printf "$tw_output" | awk 'NR==4 {print $2}') > '0:15:00' ]]; then
        timew | telegram-send --stdin
        sleep 900
    fi
    sleep 5
done
