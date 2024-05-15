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
		echo "Picture saved"

		date_now=$(date '+%Y-%m-%d')
		name=$(date '+%H%M%S_%3N')

		sudo mkdir -p ../../data/motion_pictures/"$date_now"
		cp ./pictures/"$a" ../../data/motion_pictures/"$date_now"/"$name.jpg"
		
		subject_distance=$(exiftool -s -SubjectDistance ./pictures/"$a")
		exposure_time=$(exiftool -s -ExposureTime ./pictures/"$a")
		iso=$(exiftool -s -ISO ./pictures/"$a")
		
		json_object='{
    			"File Name": "'"$name"'.jpg",
    			"Create Date": "'"$(date '+%Y-%m-%d %H:%M:%3N+%:z')"'",
    			"Create Seconds Epoch": "'"$(date -d "$date_now" '+%s')"'",
    			"Trigger": "Motion",
    			"Subject Distance": "'"$(echo "$subject_distance" | awk '{gsub(/[^0-9.]/,""); print}')"'",
    			"Exposure Time": "'"$(echo "$exposure_time" | awk '{print $NF}')"'",
    			"ISO": "'"$(echo "$iso" | awk '{print $NF}')"'"
		}'

		echo "$json_object" > ../../data/motion_pictures/"$date_now"/"$name.json"
	else
		echo "No picture saved"
	fi
}


while true; do
	take_picture
	motion_detection "$a" &
	sleep 3
done
