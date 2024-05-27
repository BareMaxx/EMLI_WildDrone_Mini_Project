#!/bin/bash

sudo apt update

# Ensure MySQL is installed
# command -v mysql tries to get the path of mysql
if ! command -v mysql &> /dev/null; then
	echo "MySQL could not be found. Installing..."
	sudo apt install -y mysql-server
	sudo mysql_secure_installation
else
	echo "MySQL is already installed"
fi

# Ensure wireless-tools is installed
if ! command -v iwgetid &> /dev/null; then
	echo "wireless-tools could not be found. Installing..."
	sudo apt install -y wireless-tools
else
	echo "wireless-tools is already installed"
fi


# Ensure that jq is installed (used for when getting the file paths from the wildlife camera)
if ! command -v jq &> /dev/null; then
	echo "jq could not be found. Installing..."
	sudo apt-get install jq
else
	echo "jq is already installed"
fi
