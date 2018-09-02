#!/usr/bin/env bash
# Start with 'custom' as argument in order to forward 444 to 443

remote_port=$1
local_port=$1

if [ "$1" == "custom" ]
then
    remote_port=444
    local_port=443
elif [ "$1" == "ssh" ]
then
    remote_port=220
    local_port=22
fi

echo "Forwarding remote port $remote_port to port $local_port"


while true
do
    echo `date --rfc-3339=seconds`   Connecting
    ssh -o ExitOnForwardFailure=yes -o TCPKeepAlive=no -o ServerAliveInterval=15 -nNT -R $remote_port:localhost:$local_port root@v22016124111441558.luckysrv.de
    sleep 60
    #if [[ $output = *"remote port forwarding failed"* ]]

done
