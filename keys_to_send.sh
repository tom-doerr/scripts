#!/bin/bash

for e in 'click 1' 'click 1'
do 
    xdotool key --clearmodifiers $e
    sleep 0.05
done
sleep 0.3
for e in f f f s
do 
    xdotool key --clearmodifiers $e
    sleep 0.3
done
