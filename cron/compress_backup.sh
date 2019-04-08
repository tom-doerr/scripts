#!/bin/bash

cd ~/Nextcloud/sonstiges/backups/
TIMESTAMP=$(date +%s)
FILE_NAME="backups_compressed_$TIMESTAMP" 
mkdir $FILE_NAME
mv *  $FILE_NAME
lrztar $FILE_NAME
rm -rf $FILE_NAME
