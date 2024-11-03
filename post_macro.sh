#!/bin/bash

# Function to copy URL and paste in next window
copy_url_paste_right() {
    # Copy URL from current window
    xdotool key ctrl+l ctrl+c

    # Focus right
    focus_right

    # Press 'n' and paste
    xdotool key n
    sleep 0.1  # Small delay to ensure 'n' is processed
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
