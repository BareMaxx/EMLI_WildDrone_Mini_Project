#!/bin/bash

# Get the directory of the script
script_dir=$(dirname "$(readlink -f "$0")")

# Navigate two levels up from the script directory
target_dir="$script_dir/../../data/logger"
mkdir -p $target_dir
touch $target_dir/syslog.log

sudo chmod -R 755 $target_dir/syslog.log

if [ $# -ne 3 ]; then
    TYPE="DEBUG"
    TAG=$1
    MESSAGE=$2
else 
    if [ $1 != "DEBUG" ] || [ $1 != "WARN" ] || [ $1 != "ERROR" ]; then
        TYPE="DEBUG"
    else 
        TYPE=$1
    fi
    TAG=$2
    MESSAGE=$3
fi

echo "$(date '+%Y-%m-%d - %H:%M:%S:%3N%:z') - $TYPE - $TAG - $MESSAGE" >> $target_dir/syslog.log
