#!/bin/bash

# sometimes you lose a window due to adhd, or disorganization
# this brings it back up and puts it in the current focus
# so you can mute yourself.

# Step 1: Look for a visible Signal window (not Preferences)
signal_info=$(hyprctl clients -j | jq -r '
  .[] 
  | select(.class == "signal" and (.title? // "" | tostring | contains("Preferences") | not)) 
  | {addr: .address, mapped: .mapped}')

signal_addr=$(echo "$signal_info" | jq -r '.addr')

if [ -n "$signal_addr" ]; then
    # Found mapped window — focus it
    hyprctl dispatch focuswindow address:$signal_addr
    exit 0
fi

# Step 2: Not open — check if Signal is in the tray
for i in $(qdbus org.kde.StatusNotifierWatcher /StatusNotifierWatcher org.kde.StatusNotifierWatcher.RegisteredStatusNotifierItems); do
    busname=$(echo "$i" | cut -d/ -f1)
    objpath="/$(echo "$i" | cut -d/ -f2-)"

    if busctl --user --no-pager --list | grep -w "$busname" | grep -q signal-desktop; then
        # Found Signal's tray icon — try to activate it
        echo "✔ Signal is in tray, unhiding..."
        busctl --user call "$busname" "$objpath" org.kde.StatusNotifierItem Activate ii 0 0
        exit 0
    fi
done

#FIXME: add check for running signal-desktop process before launching (signal checks for this too, but logs an error)
# Step 3: No window, no tray — launch fresh
echo "Signal not found, launching..."
signal-desktop &
