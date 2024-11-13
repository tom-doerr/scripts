#!/bin/bash

# Get the names of connected displays
INTERNAL=$(xrandr | grep " connected" | grep "eDP" | cut -d" " -f1)
EXTERNAL=$(xrandr | grep " connected" | grep -v "eDP" | cut -d" " -f1)

if [ -z "$EXTERNAL" ]; then
    echo "No external display detected"
    exit 1
fi

# Mirror the displays
xrandr --output "$INTERNAL" --auto --output "$EXTERNAL" --auto --same-as "$INTERNAL"
