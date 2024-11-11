#!/bin/bash

# Constants
XDOTOOL_DELAY=0.15

# Function to get random float between min and max
random_float() {
    awk -v min=$1 -v max=$2 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# Function to paste description and format
copy_url_paste_right() {
    # Focus right first
    focus_right
    sleep $XDOTOOL_DELAY

    # Press 'n' to start new post
    xdotool key n
    sleep $XDOTOOL_DELAY
    
    # Read and type the description
    description=$(cat /home/tom/git/x_twitter/description.txt)
    xdotool type "$description"
    sleep $XDOTOOL_DELAY
    
    # Type the additional text
    xdotool type '" paste the text you just copied, type another "'
    sleep $XDOTOOL_DELAY
    
    # Move cursor to start
    xdotool key Home
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
