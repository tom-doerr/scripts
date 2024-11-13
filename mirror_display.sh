#!/bin/bash

# Enable debug output
set -x

# Get the names of connected displays
INTERNAL=$(xrandr | grep " connected" | grep "eDP" | cut -d" " -f1)
EXTERNAL=$(xrandr | grep " connected" | grep -v "eDP" | cut -d" " -f1)

echo "Internal display: $INTERNAL"
echo "External display: $EXTERNAL"

if [ -z "$INTERNAL" ]; then
    echo "No internal display detected"
    exit 1
fi

if [ -z "$EXTERNAL" ]; then
    echo "No external display detected"
    exit 1
fi

# Set both displays to 1920x1080
xrandr --output "$INTERNAL" --mode 1920x1080
if [ $? -ne 0 ]; then
    echo "Failed to set internal display resolution"
    exit 1
fi

xrandr --output "$EXTERNAL" --mode 1920x1080
if [ $? -ne 0 ]; then
    echo "Failed to set external display resolution"
    exit 1
fi

# Now mirror them
xrandr --output "$EXTERNAL" --same-as "$INTERNAL"

# Show current display status
xrandr --current
