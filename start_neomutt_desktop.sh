#!/bin/zsh

if [[ $(uname --nodename) =~ 'tom-Desktop-18|desktop-20-3' ]]; then kitty neomutt; else kitty ssh -X -t gard neomutt; fi 
