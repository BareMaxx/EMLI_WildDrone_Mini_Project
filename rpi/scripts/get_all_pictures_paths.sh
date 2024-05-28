#!/bin/bash

# Get the current folder of this script
script_dir=$(dirname "$(readlink -f "$0")")

# The output dir
outer_dir=$script_dir/"../../data/pictures"

is_first=0

sh $script_dir/logger.sh DEBUG "DRONE_CONNECTION" "Drone initiated download"

echo "["
for date_dir in "$outer_dir"/*; do
	for file_path in "$date_dir"/*; do
		if [[ "$file_path" == *"json"* ]]; then
			# Check if the file is already downloaded
			if jq -e '.["Drone Copy"] | has("Drone ID") and .["Drone Copy"]["Drone ID"] != ""' "$file_path" >/dev/null; then
				continue
			fi

			if [ "$is_first" -eq 1 ]; then
				echo ","
			else
				is_first=1
			fi

			# File is not already downloaded, echo the picture and json paths
			picture_path="${file_path%.*}.jpg"
			echo "{\"picture_path\": \"${picture_path}\", \"file_path\": \"${file_path}\"}"
		fi
	done
done

echo "]"
