#!/bin/bash
#this script was made for when you have something
# go wrong with a monitor in Hyprland, like glitching or frozen screen
# or it just shows a black screen on one display

# Check if a monitor ID was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <monitor_id>"
    exit 1
fi

# Store the monitor ID
MONITOR_ID=$1

# Get the monitor name from hyprctl
MONITOR_NAME=$(hyprctl monitors | awk -v id="$MONITOR_ID" '
  /Monitor/ {
    if (match($0, /\(ID '"$MONITOR_ID"'\)/)) {
      split($2, arr, "(");
      print arr[1];
      exit;
    }
  }
')

# Check if a monitor name was found
if [ -z "$MONITOR_NAME" ]; then
    echo "Monitor with ID $MONITOR_ID not found."
    exit 1
fi

# Disable the monitor
hyprctl dispatch dpms off "$MONITOR_NAME"

# Enable the monitor
hyprctl dispatch dpms on "$MONITOR_NAME"

echo "Monitor $MONITOR_NAME with ID $MONITOR_ID has been reset."
