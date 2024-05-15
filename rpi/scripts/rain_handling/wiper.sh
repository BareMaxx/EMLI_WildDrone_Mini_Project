#!/bin/bash

# Configure serial port
# stty is a command to configure the serial port
# -F is used to define which serial port the config is changing
# raw gets the input and output from the serial without any system
    # modifying the characters
# -echo is used to disable input characters to be echoed back.
stty -F /dev/ttyACM0 raw -echo

# Marks the serial port as a file descriptor 3, used to make
# it possible to read i.e. a whole line from it
exec 3</dev/ttyACM0

echo INITIALIZING WIPER
echo '{"wiper_angle": 0}' > /dev/ttyACM0
echo DONE INITIALIZING, LISTENING FOR WIPE ACTION

mosquitto_sub -h localhost -t activate_wiper |
   while read payload ; do
      if [ "$payload" = "activate_wiper" ]; then
         echo Received $payload
         echo WIPING
         echo '{"wiper_angle": 180}' > /dev/ttyACM0
         echo '{"wiper_angle": 0}' > /dev/ttyACM0
         echo DONE
      fi
   done