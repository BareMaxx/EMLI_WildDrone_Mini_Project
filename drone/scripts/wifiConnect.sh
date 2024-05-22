#! /bin/bash

ssid="EMLI-TEAM-11"
wifi_password="SecureTheStash"

# Check if connected to any wifi
connected_to_wifi() {
	connected_wifi=$(nmcli -t -f active,ssid dev wifi | grep "^yes:")
}

# Check if connected to Raspberry Pi
connected_to_emli() {
	nmcli -t -f active,ssid dev wifi | grep -q -o -E "^yes:EMLI-TEAM-11(-[0-9]+)?"
}

start_wifi_connect() {
	# Check if is connected to wifi, if connected, disconnect :)
	if connected_to_wifi; then
		echo "Connected"
		# Get the name of the wireless interface
		wifi_interface=$(nmcli device | awk '$2=="wifi" {print $1}')

		# Disconnect from the Wi-Fi network using the wireless interface
		nmcli device disconnect "$wifi_interface"
		if [ $? -eq 0 ]; then
    			echo "Disconnected from Wifi network"
		else
    			echo "Failed to disconnect from Wifi network"
		fi
	else
		echo "Not connected"
	fi

	# Search for our wifi AP at an interval of 0.5 seconds
	while ! connected_to_emli;
	do
		wifi_ssid=$(nmcli -f SSID d wifi list | grep -o -E 'EMLI-TEAM-11(-[0-9]+)?')
		if [ -n "$wifi_ssid" ]; then
			echo "Wifi found: $wifi_ssid"
			echo "Connecting..."
			sudo nmcli device wifi connect "$wifi_ssid" password "$wifi_password"
			if [ $? -eq 0 ]; then
				echo "Connected to Wifi network: $wifi_ssid"
			else
				echo "Failed to connect to Wifi network: $wifi_ssid"
				sleep 5
			fi
		else
			echo "Wifi $wifi_ssid not found"
		fi
		sleep 0.5
	done
}
