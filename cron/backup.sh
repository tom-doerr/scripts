#!/usr/bin/env bash

TIMESTAMP=$(date +%s)
cp ~/Nextcloud/passwords/main.kdbx ~/Nextcloud/passwords/backups/main_"$TIMESTAMP".kdbx
cp -r ~/Nextcloud/sonstiges/task/  ~/Nextcloud/sonstiges/backups/task_"$TIMESTAMP"/
cp -r ~/Nextcloud/sonstiges/timewarrior/  ~/Nextcloud/sonstiges/backups/timewarrior_"$TIMESTAMP"/
