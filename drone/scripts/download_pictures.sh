#!/bin/bash

remote_user="$1"
remote_host="$2"
remote_dir="$3"

sudo mkdir -p ./test_download
sudo chmod -R 755 ./test_download

outer_dir="../../data/pictures"

for date_dir in "$outer_dir"/*; do
	echo "Folder: $date_dir"
	for picture in "$date_dir"/*; do
		echo "Path to file: $picture"
		
		if [[ "$picture" == *"json"* ]]; then
			milli=$(date '+%3N')
			date_time=$(date '+%Y-%m-%d %H:%M:%S')
			seconds_epoch="$(date -d "$date_time" '+%s').$milli"
			drone_id="WILDDRONE-001"

			updated_json=$(jq --arg drone_id "$drone_id" --argjson seconds_epoch "$seconds_epoch" \
    			'. + {"Drone Copy": {"Drone ID": $drone_id, "Seconds Epoch": $seconds_epoch}}' "$picture")		
			echo "$updated_json" > "$picture"
		fi

		sudo scp "$picture" "$remote_user@$remote_host:$remote_dir/"
	done
done
