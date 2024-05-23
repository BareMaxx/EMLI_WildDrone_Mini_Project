#!/bin/bash
script_dir=$(dirname "$(readlink -f "$0")")
sh $script_dir/../logger.sh DEBUG "RAIN_DETERMINER" "Initializing"
mosquitto_sub -u "my_user" -P "SecureTheStash" -t rain_sensed |
   while read payload ; do
      
      if echo "$payload" | grep -q '"rain_detect": 1'; then
         sh $script_dir/../logger.sh DEBUG "RAIN_DETERMINER" "Rain detected"
         sh $script_dir/../logger.sh DEBUG "RAIN_DETERMINER" "Publishing to wiper"
         mosquitto_pub -u "my_user" -P "SecureTheStash" -h localhost -t activate_wiper -m "activate_wiper"
      fi

   done
