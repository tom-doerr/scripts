#!/bin/bash


for subject in cs qc
do
    ~/git/scripts/get_goal_delta.sh $subject 2021-09-15 2
    echo ==========================
done
