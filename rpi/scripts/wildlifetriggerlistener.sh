#!/bin/bash
script_dir=$(dirname "$(readlink -f "$0")")
sh $script_dir/logger.sh DEBUG "External_TRIGGER_LISTENER" "Initializing"
mosquitto_sub -u "my_user" -P "SecureTheStash" -t "my_user/external-trigger" |
   while read payload ; do
      if [ "$payload" = "event" ]; then
        sh $script_dir/logger.sh DEBUG "EXTERNAL_TRIGGER_LISTENER" "External trigger!!! Taking photo"
        sh $script_dir/take_photo.sh "External"
      fi

   done