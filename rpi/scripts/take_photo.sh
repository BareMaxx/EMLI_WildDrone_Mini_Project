trigger="$1"

milli=$(date '+%3N')
date_now=$(date '+%Y-%m-%d')
name="$(date '+%H%M%S')_$milli"
create_date="$(date '+%Y-%m-%d %H:%M:%S').$milli$(date '+%:z')"         
date_time=$(date '+%Y-%m-%d %H:%M:%S')

sudo mkdir -p ../../data/pictures/"$date_now"
picturePath=../../data/pictures/"$date_now"/"$name.jpg"
sudo rpicam-still -t 0.01 -o "$picturePath"

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

