#! /bin/bash

while :
do
	
	if [ "$(nmcli -f SSID d wifi list | grep -c EMLI-TEAM-11)" -eq 1 ]; then
	 echo "WIFI FOUND"
	else
	 echo "NO WIFI"
	fi
done
