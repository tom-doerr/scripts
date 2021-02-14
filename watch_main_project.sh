#!/bin/bash
IFS=$'\n'
while true 
do 
    clear
    echo ""
    sub_goals="$(head -n 3 ~/main_project)"
    for e in $sub_goals
    do
        echo -n "  "
        echo $e
    done
    sleep 60
done      
