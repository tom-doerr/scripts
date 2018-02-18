#!/usr/bin/env bash

TIMESTAMP=$(date +%s)
cp ~/ownCloud/passwords/main.kdbx ~/ownCloud/passwords/backups/main_"$TIMESTAMP".kdbx
cp -r ~/ownCloud/sonstiges/task/  ~/ownCloud/sonstiges/backups/task_"$TIMESTAMP"/
cp -r ~/ownCloud/sonstiges/timewarrior/  ~/ownCloud/sonstiges/backups/timewarrior_"$TIMESTAMP"/
