#!/bin/bash

server_ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
echo "Server's IP: $server_ip"

client_ip="10.0.0.10" #localhost
client_user="jeinere"

ssh $client_user@$client_ip sudo bash mini_project/EMLI_WildDrone_Mini_Project/rpi/scripts/syncChrony.sh $server_ip

# sudo systemctl restart chrony
