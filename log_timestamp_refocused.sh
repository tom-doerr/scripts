#!/bin/bash

timestamp=$(date +%s)
cd ~/git/refocused_timestamps_log
git pull
echo $timestamp >> log
git commit -am "Auto commit"
git push
