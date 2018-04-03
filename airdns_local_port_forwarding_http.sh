#!/bin/bash

ssh -o TCPKeepAlive=no -o ServerAliveInterval=15 -L 8080:localhost:80 -nNT tom@abcd.airdns.org -p 39836
