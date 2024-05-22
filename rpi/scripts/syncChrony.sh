#!/bin/bash


chrony_conf_file="/etc/chrony/chrony.conf"
arg_server_ip=$1

sudo sed -i '/^server /d' $chrony_conf_file
echo "server $arg_server_ip iburst" | sudo tee -a $conf_file

sudo systemctl restart chrony
