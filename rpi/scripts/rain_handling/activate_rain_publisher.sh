#!/bin/bash

sh ../logger.sh DEBUG "RAIN_DETERMINER" "Initializing"
mosquitto_sub -t rain_sensed |
   while read payload ; do
      
      if echo "$payload" | grep -q '"rain_detect": 1'; then
         sh ../logger.sh DEBUG "RAIN_DETERMINER" "Rain detected"
         sh ../logger.sh DEBUG "RAIN_DETERMINER" "Publishing to wiper"
         mosquitto_pub -h localhost -t activate_wiper -m "activate_wiper"
      fi

   done