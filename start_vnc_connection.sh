#!/bin/bash

display_number="30"
user_name='tom'
port='59'"$display_number"; ssh $user_name@abcd.airdns.org -p 39836 -N -L "$port":localhost:"$port" &
sleep 1
xtigervncviewer  <(ssh $user_name@abcd.airdns.org -p 39836 cat /home/$user_name/.vnc/passwd) :"$display_number"
