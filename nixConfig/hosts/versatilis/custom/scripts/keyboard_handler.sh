#!/bin/sh
export PATH="/run/current-system/sw/bin"

LOGFILE="/tmp/keyboard_handler.log"
exec > "$LOGFILE" 2>&1
set -x 

if lsusb | grep -iq "ASUS Zenbook Duo Keyboard"; then
  # Keyboard is attached via pins - Disable bottom screen
  hyprctl keyword monitor "eDP-2, disable";
else
  # Keyboard is detached - Enable bottom screen
  hyprctl keyword monitor "eDP-1, 2880x1800@120, 0x0, 2"
  hyprctl keyword monitor "eDP-2, 2880x1800@120, 0x1800, 2"
fi
