#!/bin/bash

# Function to get random float between min and max
random_float() {
    awk -v min=$1 -v max=$2 'BEGIN{srand(); print min+rand()*(max-min)}'
}

# Function to copy URL and paste in next window
copy_url_paste_right() {
    # Copy URL from current window
    xdotool key ctrl+l ctrl+c

    # Focus right
    focus_right

    # Press 'n', enter, tab 9 times, and paste with random delay
    xdotool key n
    sleep 0.1  # Small delay to ensure 'n' is processed
    xdotool key Return
    xdotool key Tab Tab Tab Tab Tab Tab Tab Tab Tab
    xdotool key Return BackSpace
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
