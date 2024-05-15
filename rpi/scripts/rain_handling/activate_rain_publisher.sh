#!/bin/bash

mosquitto_sub -t rain_sensed |
   while read payload ; do
      echo Received $payload
      
      if echo "$payload" | grep -q '"rain_detect": 1'; then
         echo It is raining
         echo Publishing to wiper
         mosquitto_pub -h localhost -t activate_wiper -m "activate_wiper"
      fi

   done