#!/bin/bash

for e in 'click 1' 'click 1' f f f s
do 
    xdotool key --clearmodifiers $e
    sleep 0.2
done
