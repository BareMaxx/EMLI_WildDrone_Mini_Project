#!/bin/bash

# Check if we can find the wifi interface
wifi_interface=$(awk 'NR==3 {print $1}' /proc/net/wireless | sed 's/://')
if [ -z "$wifi_interface" ]; then
    echo "No wireless interface found."
    exit 1
fi

# Wifi name
wifi_ssid=$(iwgetid -r $wifi_interface)


# Extract link quality and signal level
read -r link_quality signal_level _ < <(awk 'NR==3 {print int($3), int($4)}' /proc/net/wireless)

# echo "Wifi SSID: $wifi_ssid"
# echo "Link Quality: $link_quality/70"
# echo "Signal Level: $signal_level dBm"

echo "$wifi_ssid $link_quality $signal_level"
