#!/bin/bash

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
    *)
        echo "Usage: $0 [right]"
        echo "Available movements:"
        echo "  right    - Focus window to the right"
        exit 1
        ;;
esac
