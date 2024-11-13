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

# Get common resolution (1920x1080 is usually safe)
RESOLUTION="1920x1080"

# Turn off both displays first
xrandr --output "$INTERNAL" --off
xrandr --output "$EXTERNAL" --off

# Now enable them with mirroring
xrandr --output "$INTERNAL" --mode "$RESOLUTION" --output "$EXTERNAL" --mode "$RESOLUTION" --same-as "$INTERNAL"

# If that fails, try auto mode
if [ $? -ne 0 ]; then
    echo "Failed to set specific resolution, trying auto mode..."
    xrandr --output "$INTERNAL" --auto --output "$EXTERNAL" --auto --same-as "$INTERNAL"
fi

# Show current display status
xrandr --current
