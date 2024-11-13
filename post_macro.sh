#!/bin/bash

# Constants
XDOTOOL_DELAY=0.75

# Function to get random float between min and max
random_float() {
    awk -v min=$1 -v max=$2 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# Function to copy URL and paste in next window
copy_url_paste_right() {
    # Focus right first
    focus_right
    sleep $XDOTOOL_DELAY

    # Press 'n' and initial paste
    xdotool key n
    sleep $XDOTOOL_DELAY
    
    xdotool key ctrl+v
    sleep 0.25
    sleep $XDOTOOL_DELAY

    # Continue with tabs
    for i in {1..13}; do
        xdotool key Tab
        sleep 0.05
    done
    sleep $XDOTOOL_DELAY
    xdotool key Return
    sleep $XDOTOOL_DELAY
    xdotool key BackSpace
    sleep $XDOTOOL_DELAY
    
    # Move back left to copy URL
    i3-msg focus left
    sleep $XDOTOOL_DELAY
    xdotool key ctrl+l
    sleep $XDOTOOL_DELAY
    xdotool key ctrl+c
    sleep $XDOTOOL_DELAY
    xdotool key Escape
    sleep $XDOTOOL_DELAY

    # Move right again
    focus_right
    sleep $XDOTOOL_DELAY
    sleep $(random_float 0.1 0.25)  # Random delay before paste
    xdotool key ctrl+v
    sleep $XDOTOOL_DELAY
    
    # Move up twice
    xdotool key Up
    sleep $XDOTOOL_DELAY
    xdotool key Up
    sleep $XDOTOOL_DELAY
    
    # Move cursor to start
    xdotool key Home
    sleep $XDOTOOL_DELAY
    
    # Read and type the description with quotes
    description=$(cat /home/tom/git/x_twitter/description.txt)
    xdotool type '"'
    sleep $XDOTOOL_DELAY
    xdotool type "$description"
    sleep $XDOTOOL_DELAY
    xdotool type '"'
    sleep $XDOTOOL_DELAY
    
    # Move cursor to the very beginning and top
    xdotool key ctrl+Home
    sleep $XDOTOOL_DELAY
}

# Function to focus right
focus_right() {
    # Get the current window ID
    current=$(xdotool getwindowfocus)

    # Move focus right in i3
    i3-msg focus right

    # Get the new window ID
    new=$(xdotool getwindowfocus)

    # If the window ID hasn't changed, we were at the rightmost window
    if [ "$current" = "$new" ]; then
        notify-send "No window to the right"
    fi
}

# Execute the copy URL and paste function
copy_url_paste_right
