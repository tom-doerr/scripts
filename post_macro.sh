#!/bin/bash

# Constants
XDOTOOL_DELAY=0.3

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
    sleep $XDOTOOL_DELAY
    xdotool key shift+Tab shift+Tab shift+Tab
    sleep $XDOTOOL_DELAY

    # Move back left to copy URL
    i3-msg focus left
    sleep $XDOTOOL_DELAY
    xdotool key ctrl+l
    sleep $XDOTOOL_DELAY
    xdotool key ctrl+c
    sleep $XDOTOOL_DELAY

    # Move right again
    focus_right
    sleep $XDOTOOL_DELAY

    # Continue with tabs and final paste
    xdotool key Tab Tab Tab Tab Tab Tab Tab Tab Tab Tab Tab Tab Tab Tab
    sleep $XDOTOOL_DELAY
    xdotool key Return
    sleep $XDOTOOL_DELAY
    xdotool key BackSpace
    sleep $XDOTOOL_DELAY
    sleep $(random_float 0.2 0.5)  # Random delay before paste
    xdotool key ctrl+v
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
