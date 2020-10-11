#!/bin/bash

if [[ $(uname --nodename) == 'tom-Desktop-18' ]] || [[ $(uname --nodename) == 'desktop-20' ]]; then kitty --single-instance zsh; else kitty --single-instance ssh -X -t gard zsh --login; fi 
