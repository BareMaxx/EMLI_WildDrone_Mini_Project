#!/bin/bash

# Current script folder
script_dir=$(dirname "$readlink -f "$0")")

outer_dir=$script_dir/"../../data/pictures"

drone_id="$1"
file_path="$2"

echo "Drone ID: $drone_id, Path to JSON file: $file_path"

milli=$(date '+%3N')
date_time=$(date '+%Y-%m-%d %H:%M:%S')
seconds_epoch="$(date -d "$date_time" '+%s').$milli"

echo "Updating json file..."
filename=$(basename "$file_path")
echo "Filename: $filename"

cat $file_path

updated_json=$(jq --arg drone_id "$drone_id" --argjson seconds_epoch "$seconds_epoch" \
'. + {"Drone Copy": {"Drone ID": $drone_id, "Seconds Epoch": $seconds_epoch}}' "$file_path")
echo "$updated_json" > "$file_path"

sh $script_dir/logger.sh DEBUG "DRONE_CONNECTION" "Drone $drone_id downloaded file $filename"
