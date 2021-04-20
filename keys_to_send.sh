#!/bin/bash

for e in f f f s
do 
    xdotool key --clearmodifiers $e
    sleep 0.1
done
