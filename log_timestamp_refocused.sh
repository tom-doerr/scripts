#!/bin/bash -i

set -x 

OBJ_INDICATOR_FILENAME='/tmp/had_no_obj_tag'

if [[ $(hostname) == "tom-ThinkPad-L460-18" ]]
then
    ssh gard '/home/tom/git/scripts/log_timestamp_refocused.sh'
fi

if ! [[ $(timew) =~ ' obj' ]]
then
    touch $OBJ_INDICATOR_FILENAME
fi


if [[ $(timew) =~ ' med' ]]
then
    if [[ -f $OBJ_INDICATOR_FILENAME ]]
    then
        rt med obj
        rm $OBJ_INDICATOR_FILENAME
    else
        rt med
    fi
else
    at med
    timestamp=$(date +%s)
    cd ~/git/refocused_timestamps_log
    git pull
    echo $timestamp >> log
    git commit -am "Auto commit"
    git push
fi
