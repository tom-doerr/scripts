#!/bin/bash


#!/bin/bash

SSID="Vorname's Galaxy Z Fold3 5G"
INTERVAL=1  # check every 60 seconds

while true; do
    # Check if already connected to the desired network
    if nmcli -t -f active,ssid dev wifi | grep -q "^yes:$SSID$"; then
        echo "Already connected to $SSID"
    else
        # Check if the specific SSID is available
        if nmcli device wifi list | grep -q "$SSID"; then
            echo "Network found: $SSID"
            # Attempt to connect to the network
            nmcli device wifi connect "$SSID"
            echo "Connected to $SSID"
        else
            echo "Network $SSID not found, checking again in $INTERVAL seconds..."
        fi
    fi
    sleep $INTERVAL  # Wait for the specified interval
done
