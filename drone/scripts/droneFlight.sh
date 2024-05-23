#! /bin/bash

droneID="WILDDRONE-001"

# Ensure that the database is set up. This sets up the database and table and allows to insert_row
. setupDatabase.sh

# Dot command so we can call the functions within the script
. wifiConnect.sh

start_search() {
	# Search and connect to an rpi device
	start_wifi_connect
	# commands under start_wifi_connect, runs when the wifi is connected

	# Tell the rpi to connect to the drone's Chrony server to sync its date and time
	bash timeSync.sh

	# While we are connected to the rpi, do...
	while connected_to_emli;
	do
		# continuously log the wifi stats every second
		wifi_stats=$(bash wifiStats.sh)
		read -r wifi_ssid link_quality signal_level <<< "$wifi_stats"
		insert_row "$wifi_ssid" "$link_quality" "$signal_level"

		sleep 0.1
	done

	start_search
}

start_search
