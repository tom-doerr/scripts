#!/bin/bash

symlink_harddrive_folder=~/8tb_hdd

while true
do
    # check if symlink is not broken
    if [ ! -L $symlink_harddrive_folder ]
    then
        echo "symlink is broken, please mount the harddrive"
        sleep 10
    else
        touch file_getting_touched_preventing_hdd_spinning_down
        sleep 9m
    fi
done        
