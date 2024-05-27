#!/bin/bash
script_dir=$(dirname "$(readlink -f "$0")")

take_picture() {
	sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "Taking picture"
	a=$(ls -t "$script_dir/pictures/" | tail -n 1)
	sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "File to be overwritten: $a"
	sudo rpicam-still -t 0.01 -o "$script_dir/pictures/$a"
}

motion_detection() {
	sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "Checking for motion"
	motion=$(python $script_dir/motion_detect.py $script_dir/pictures/picture1.jpg $script_dir/pictures/picture2.jpg)
	motion_detected="Motion detected"
	if [ "$motion" = "$motion_detected" ]; then
		sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "Motion detected, saving photo"

		milli=$(date '+%3N')
		date_now=$(date '+%Y-%m-%d')
		name="$(date '+%H%M%S')_$milli"
		create_date="$(date '+%Y-%m-%d %H:%M:%S').$milli$(date '+%:z')"		
		date_time=$(date '+%Y-%m-%d %H:%M:%S')

		sudo mkdir -p $script_dir/../../data/pictures/"$date_now"
		sudo chmod -R 755 $script_dir/../../data/pictures/"$date_now"
		cp $script_dir/pictures/"$a" $script_dir/../../data/pictures/"$date_now"/"$name.jpg"
		
		subject_distance=$(exiftool -s -SubjectDistance $script_dir/pictures/"$a")
		exposure_time=$(exiftool -s -ExposureTime $script_dir/pictures/"$a")
		iso=$(exiftool -s -ISO $script_dir/pictures/"$a")
		
		json_object='{
    			"File Name": "'"$name.jpg"'",
    			"Create Date": "'"$create_date"'",
    			"Create Seconds Epoch": "'"$(date -d "$date_time" '+%s').$milli"'",
    			"Trigger": "Motion",
    			"Subject Distance": "'"$(echo "$subject_distance" | awk '{gsub(/[^0-9.]/,""); print}')"'",
    			"Exposure Time": "'"$(echo "$exposure_time" | awk '{print $NF}')"'",
    			"ISO": "'"$(echo "$iso" | awk '{print $NF}')"'"
		}'
		sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "Photo saved in: $date_now/$name.jpg"
		sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "JSON saved in: $date_now/$name.json"
		echo "$json_object" > $script_dir/../../data/pictures/"$date_now"/"$name.json"
	else
		sh $script_dir/logger.sh DEBUG "MOTION_DETECTION" "No motion detected, photo not saved"
	fi
}


while true; do
	take_picture
	motion_detection "$a" &
	sleep 3
done
