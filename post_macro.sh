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

# Main script
case "$1" in
    "right")
        focus_right
        ;;
    "paste-url")
        copy_url_paste_right
        ;;
    *)
        echo "Usage: $0 [right|paste-url]"
        echo "Available commands:"
        echo "  right     - Focus window to the right"
        echo "  paste-url - Copy URL and paste in right window"
        exit 1
        ;;
esac
