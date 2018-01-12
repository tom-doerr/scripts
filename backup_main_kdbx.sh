#!/usr/bin/env bash

TIMESTAMP=$(date +%s)
cp ~/ownCloud/passwords/main.kdbx ~/ownCloud/passwords/backups/main_"$TIMESTAMP".kdbx
