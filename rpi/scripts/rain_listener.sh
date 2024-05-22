#!/bin/bash

exec 3</dev/ttyACM0

while true; do
    if read -r line <&3; then
        if echo "$line" | grep -q '"rain_detect": 1'; then
            echo "Hello World!"
            $(mosquitto_pub -h localhost -t rain_sensed -m "IT IS RAINING MEN HALLELUJA")
        fi
    fi
done
