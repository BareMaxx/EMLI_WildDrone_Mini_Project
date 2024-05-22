trigger="$1"
sh /logger.sh DEBUG "TAKE_PHOTO" "Triggered by $trigger"
milli=$(date '+%3N')
date_now=$(date '+%Y-%m-%d')
name="$(date '+%H%M%S')_$milli"
create_date="$(date '+%Y-%m-%d %H:%M:%S').$milli$(date '+%:z')"         
date_time=$(date '+%Y-%m-%d %H:%M:%S')

sudo mkdir -p ../../data/pictures/"$date_now"
sh /logger.sh DEBUG "TAKE_PHOTO" "Created folder: $date_now"

sudo chmod -R 755 ../../data/pictures/"$date_now"
picturePath=../../data/pictures/"$date_now"/"$name.jpg"
sh /logger.sh DEBUG "TAKE_PHOTO" "Taking photo"
sudo rpicam-still -t 0.01 -o "$picturePath"

sh /logger.sh DEBUG "TAKE_PHOTO" "Photo saved in $date_now/$name.jpg"

subject_distance=$(exiftool -s -SubjectDistance "$picturePath")
exposure_time=$(exiftool -s -ExposureTime "$picturePath")
iso=$(exiftool -s -ISO "$picturePath")

json_object='{
"File Name": "'"$name.jpg"'",
"Create Date": "'"$create_date"'",
"Create Seconds Epoch": "'"$(date -d "$date_time" '+%s').$milli"'",
"Trigger": "'"$trigger"'",
"Subject Distance": "'"$(echo "$subject_distance" | awk '{gsub(/[^0-9.]/,""); print}')"'",
"Exposure Time": "'"$(echo "$exposure_time" | awk '{print $NF}')"'",
"ISO": "'"$(echo "$iso" | awk '{print $NF}')"'"
}'



echo "$json_object" > ../../data/pictures/"$date_now"/"$name.json"

sh /logger.sh DEBUG "TAKE_PHOTO" "JSON saved in: $date_now/$name.json"

