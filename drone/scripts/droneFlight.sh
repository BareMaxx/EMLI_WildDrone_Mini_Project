#! /bin/bash

droneID="WILDDRONE-001"

# Dot command to allow this script to access the variables in the wifiConnect script
. wifiConnect.sh

start_wifi_connect
# commands under start_wifi_connect, runs when the wifi is connected

bash timeSync.sh
