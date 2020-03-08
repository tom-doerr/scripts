#!/bin/bash

if [[ $(uname --nodename) == 'tom-Desktop-18' ]]; then kitty neomutt; else kitty ssh -X -t gard neomutt; fi 
