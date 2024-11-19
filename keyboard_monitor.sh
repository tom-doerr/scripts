#!/bin/bash

KEYBOARD_SCRIPT="/home/tom/git/dotfiles/keyboard_config/start.sh"
LOG_FILE="/tmp/keyboard_monitor.log"

run_keyboard_script() {
    if [ -x "$KEYBOARD_SCRIPT" ]; then
        echo "$(date): Running keyboard script" >> "$LOG_FILE"
        "$KEYBOARD_SCRIPT" >> "$LOG_FILE" 2>&1
    else
        echo "$(date): Keyboard script not found or not executable: $KEYBOARD_SCRIPT" >> "$LOG_FILE"
    fi
}

echo "$(date): Starting keyboard monitor" >> "$LOG_FILE"
run_keyboard_script

udevadm monitor --subsystem-match=input --udev | while read -r line
do
    echo "$(date): $line" >> "$LOG_FILE"
    if echo "$line" | grep -q "17EF:6047"; then
        echo "$(date): Lenovo keyboard event detected" >> "$LOG_FILE"
        # Wait a short time for the device to stabilize
        sleep 1
        run_keyboard_script
    fi
done
