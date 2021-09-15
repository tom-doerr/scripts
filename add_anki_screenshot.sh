#!/bin/bash

IMAGE_PATH=/tmp/screenshot_for_anki.png 
#import -window $(xwininfo -tree -root | awk '/TUM Cognitive Systems/ {print $1}') $IMAGE_PATH
import -window $(xwininfo -tree -root | awk '/Downloads.*.pdf/ {print $1}') $IMAGE_PATH
xclip -sel c -t image/png < $IMAGE_PATH  
sleep 0.1
xdotool key Tab
xdotool key ctrl+v
xdotool key Shift+Tab
