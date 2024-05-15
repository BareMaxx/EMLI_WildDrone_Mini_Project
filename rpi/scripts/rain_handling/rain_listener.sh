#!/bin/bash

# Configure serial port
# stty is a command to configure the serial port
# -F is used to define which serial port the config is changing
# raw gets the input and output from the serial without any system
    # modifying the characters
# -echo is used to disable input characters to be echoed back.
stty -F /dev/ttyACM0 raw -echo

# Marks the serial port as a file descripter 3, used to make
# it possible to read i.e. a whole line from it
exec 3</dev/ttyACM0

# Clear any existing data in the serial buffer
# Basically we use head to read 0 lines from /dev/ttyACM0.
# By during this, the buffer from /dev/ttyACM0 has been consumed
# even when 0 lines were read.
# &>/dev/null is used to discard any messages which could appear from
# the head command. 
head -n 0 <&3 &>/dev/null
sh ../logger.sh DEBUG "RAIN_LISTENER" "INITIALIZING"
while true; do
    # Read the newest line from the serial port
    if read -r line <&3; then
        $(mosquitto_pub -h localhost -t rain_sensed -m "$line")
    fi
done
sh ../logger.sh ERROR "RAIN_LISTENER" "Outside while loop, this is not possible."
