#!/bin/bash

# Dependencies check
if ! command -v inotifywait >/dev/null 2>&1; then
    echo "Error: inotifywait not found. Please install with: sudo apt-get install inotify-tools"
    exit 1
fi

# Function to show usage
show_help() {
    echo "Usage: $0 [-h|--help] [-d|--disconnect]"
    echo
    echo "Mirror display to external monitor or disconnect it"
    echo
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -d, --disconnect Disconnect external display and restore internal display"
}

# Enable debug output
set -x

# Function to configure displays
configure_displays() {
    # Get the names of connected displays
    echo "Debug: Full xrandr output:"
    xrandr

    echo "Debug: Searching for connected displays..."
    INTERNAL=$(xrandr | grep " connected" | grep "eDP" | cut -d" " -f1)
    EXTERNAL=$(xrandr | grep -E " connected|1920x1080" | grep -v "eDP" | cut -d" " -f1 | tr -d '\n')

    echo "Internal display: $INTERNAL"
    echo "External display: $EXTERNAL"
    echo "Debug: Number of external displays found: $(echo "$EXTERNAL" | wc -l)"

    if [ -z "$INTERNAL" ]; then
        echo "No internal display detected"
        return 1
    fi

    if [ "$DISCONNECT" = true ]; then
        # Reset displays first
        xrandr --output "$EXTERNAL" --off
        xrandr --output "$INTERNAL" --auto
        
        # Double check external display is off
        if [ ! -z "$EXTERNAL" ]; then
            xrandr --output "$EXTERNAL" --off
        fi
    elif [ ! -z "$EXTERNAL" ]; then
        # Check if 1920x1080 is available
        echo "Debug: Available modes for external display:"
        EXTERNAL_MODES=$(xrandr | grep "^$EXTERNAL connected" -A20)
        echo "$EXTERNAL_MODES"
        
        if echo "$EXTERNAL_MODES" | grep -q "1920x1080.*60\.00"; then
            EXTERNAL_RES="1920x1080"
        else
            # Fallback to highest available resolution
            EXTERNAL_RES=$(echo "$EXTERNAL_MODES" | grep -o "[0-9]\+x[0-9]\+" | head -n1)
        fi
        
        if [ -z "$EXTERNAL_RES" ]; then
            echo "No valid resolution found for external display"
            return 1
        fi
        
        echo "Debug: Using resolution: $EXTERNAL_RES"
        
        # Set both displays to the same resolution
        xrandr --output "$INTERNAL" --mode "$EXTERNAL_RES"
        if [ $? -ne 0 ]; then
            echo "Failed to set internal display resolution"
            return 1
        fi

        xrandr --output "$EXTERNAL" --mode "$EXTERNAL_RES"
        if [ $? -ne 0 ]; then
            echo "Failed to set external display resolution"
            return 1
        fi

        # Position the external display and enable it
        xrandr --output "$EXTERNAL" --pos 0x0
        xrandr --output "$EXTERNAL" --same-as "$INTERNAL"
    fi

    # Show current display status
    xrandr --current
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--disconnect)
            DISCONNECT=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Initial configuration
configure_displays

if [ "$DISCONNECT" != true ]; then
    echo "Monitoring for display changes..."
    while true; do
        # Watch for changes in display configuration
        inotifywait -q -e modify /sys/class/drm/card*/status >/dev/null 2>&1
        
        # Wait a moment for the system to recognize the display
        sleep 2
        
        # Reconfigure displays
        configure_displays
    done
fi
