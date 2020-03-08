#!/bin/bash

if [[ $(uname --nodename) == 'tom-Desktop-18' ]]; then kitty zsh; else kitty ssh -X -t gard neomutt; fi 
