#!/bin/bash


chrony_conf_file="/etc/chrony/chrony.conf"
arg_server_ip=$1

sudo sed -i '/^server /d' $chrony_conf_file  && echo "Existing server lines removed successfully" || echo "Failed to remove existing server lines"
#echo "server $arg_server_ip iburst" | sudo tee -a $conf_file  && echo "New server line added successfully" || echo "Failed to add new server line"

echo "server $arg_server_ip iburst" >> $chrony_conf_file

sudo systemctl restart chrony
