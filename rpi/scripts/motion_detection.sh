
#!/bin/bash

cd pictures/

take_picture() {
	sh ../logger.sh DEBUG "MOTION_DETECTION" "Taking picture"
	a=$(ls -t "./" | tail -n 1)
	sh ../logger.sh DEBUG "MOTION_DETECTION" "File to be overwritten: $a"
	sudo rpicam-still -t 0.01 -o "$a"
}

motion_detection() {
	cd ..
	sh /logger.sh DEBUG "MOTION_DETECTION" "Checking for motion"
	motion=$(python motion_detect.py ./pictures/picture1.jpg ./pictures/picture2.jpg)
	motion_detected="Motion detected"
	if [ "$motion" = "$motion_detected" ]; then
		sh /logger.sh DEBUG "MOTION_DETECTION" "Motion detected, saving photo"

		milli=$(date '+%3N')
		date_now=$(date '+%Y-%m-%d')
		name="$(date '+%H%M%S')_$milli"
		create_date="$(date '+%Y-%m-%d %H:%M:%S').$milli$(date '+%:z')"		
		date_time=$(date '+%Y-%m-%d %H:%M:%S')

		sudo mkdir -p ../../data/pictures/"$date_now"
		sudo chmod -R 755 ../../data/pictures/"$date_now"
		cp ./pictures/"$a" ../../data/pictures/"$date_now"/"$name.jpg"
		
		subject_distance=$(exiftool -s -SubjectDistance ./pictures/"$a")
		exposure_time=$(exiftool -s -ExposureTime ./pictures/"$a")
		iso=$(exiftool -s -ISO ./pictures/"$a")
		
		json_object='{
    			"File Name": "'"$name.jpg"'",
    			"Create Date": "'"$create_date"'",
    			"Create Seconds Epoch": "'"$(date -d "$date_time" '+%s').$milli"'",
    			"Trigger": "Motion",
    			"Subject Distance": "'"$(echo "$subject_distance" | awk '{gsub(/[^0-9.]/,""); print}')"'",
    			"Exposure Time": "'"$(echo "$exposure_time" | awk '{print $NF}')"'",
    			"ISO": "'"$(echo "$iso" | awk '{print $NF}')"'"
		}'
		sh /logger.sh DEBUG "MOTION_DETECTION" "Photo saved in: $date_now/$name.jpg"
		sh /logger.sh DEBUG "MOTION_DETECTION" "JSON saved in: $date_now/$name.json"
		echo "$json_object" > ../../data/pictures/"$date_now"/"$name.json"
	else
		sh /logger.sh DEBUG "MOTION_DETECTION" "No motion detected, photo not saved"
	fi
}


while true; do
	take_picture
	motion_detection "$a" &
	sleep 3
done
