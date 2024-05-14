#!/bin/bash

take_picture() {
	cd pictures/
	a=$(ls -t "./" | tail -n 1)
	echo "File to be overwritten: $a"
	sudo rpicam-still -t 0.01 -o "$a"
}

motion_detection() {
	python motion_detect.py ./pictures/picture1.jpg ./pictures/picture2.jpg
}


while true; do
	take_picture &
	motion_detection &
	sleep 4
done
