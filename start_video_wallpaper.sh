#!/bin/bash

#video_path=~/Videos/'8H A Beautiful Day in Nature [k-ZXEDMEaew].webm'
#video_path=~/Videos/'ASMR Highway Driving at Night (No Talking, No Music) - Busan to Seoul, Korea [nABR88G_2cE].webm'
video_path=~/Videos/'4K Scenic Byway 12 ｜ All American Road in Utah, USA - 5 Hour of Road Drive with Relaxing Music [ZOZOqbK86t0].webm'

xwinwrap -ov -g 1920x1200+0+0 -- mpv -wid WID "$video_path" --no-osc --no-osd-bar --loop-file --player-operation-mode=cplayer --no-audio --panscan=1.0 --no-input-default-bindings &
