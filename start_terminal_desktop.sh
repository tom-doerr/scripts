#!/bin/bash

if [[ $(uname --nodename) == 'tom-Desktop-18' ]] || [[ $(uname --nodename) == 'desktop-20' ]] || [[ $(uname --nodename) == 'desktop-20-3' ]]; then kitty zsh; else kitty ssh -X -t gard zsh --login; fi 
