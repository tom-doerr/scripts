#!/bin/bash

while true
do
    ssh -N -R 7007:localhost:7007 g10s
    sleep 1
done
