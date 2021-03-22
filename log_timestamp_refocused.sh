#!/bin/bash -i

set -x 

if [[ $(timew) =~ ' med' ]]
then
    rt med
else
    at med
    timestamp=$(date +%s)
    cd ~/git/refocused_timestamps_log
    git pull
    echo $timestamp >> log
    git commit -am "Auto commit"
    git push
fi
