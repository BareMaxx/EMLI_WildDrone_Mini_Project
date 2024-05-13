#!/bin/bash

take_picture() {
	cd pictures/
	a=$(ls -t "./" | tail -n 1)
	echo "File to be overwritten: $a"
	sudo rpicam-still -t 0.01 -o "$a"
}

while true; do
	take_picture &
	sleep 2
done
