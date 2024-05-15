#!/bin/bash

cd pictures/

take_picture() {
	a=$(ls -t "./" | tail -n 1)
	echo "File to be overwritten: $a"
	sudo rpicam-still -t 0.01 -o "$a"
}

motion_detection() {
	cd ..
	motion=$(python motion_detect.py ./pictures/picture1.jpg ./pictures/picture2.jpg)
	echo "$motion"
	motion_detected="Motion detected"
	if [ "$motion" = "$motion_detected" ]; then
		echo "test of if statement"
		cp ./pictures/"$a" ./motion_pictures/"$(date '+%Y-%m-%d_%H:%M:%S')_$a"
	else
		echo "No picture saved"
	fi
}


while true; do
	take_picture
	motion_detection "$a" &
	sleep 3
done
