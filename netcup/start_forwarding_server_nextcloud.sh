#!/usr/bin/env bash

while true
do
    ssh -o TCPKeepAlive=no -o ServerAliveInterval=15 -nNT -R 444:localhost:443 root@v22016124111441558.luckysrv.de
done
