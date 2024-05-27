#!/bin/bash

remote_user="$1"
remote_host="$2"
remote_dir="$3"
drone_id="$4"

outer_dir="../../data/pictures"

for date_dir in "$outer_dir"/*; do
        echo "Folder: $date_dir"
        for file_path in "$date_dir"/*; do
                milli=$(date '+%3N')
                date_time=$(date '+%Y-%m-%d %H:%M:%S')
                seconds_epoch="$(date -d "$date_time" '+%s').$milli"
                #drone_id="WILDDRONE-001"

                if [[ "$file_path" == *"json"* ]]; then
                        picture_path="${file_path%.*}.jpg"
                        echo "Path to picture file: $picture_path"
                        echo "Path to JSON file: $file_path"

                        if jq -e '.["Drone Copy"] | has("Drone ID") and .["Drone Copy"]["Drone ID"] == "'"$drone_id"'"' "$file_path" >/dev/null; then
                                continue
                        else
                                updated_json=$(jq --arg drone_id "$drone_id" --argjson seconds_epoch "$seconds_epoch" \
                                '. + {"Drone Copy": {"Drone ID": $drone_id, "Seconds Epoch": $seconds_epoch}}' "$file_path")
                                echo "$updated_json" > "$file_path"

                                sudo scp "$file_path" "$remote_user@$remote_host:$remote_dir/"
                                sudo scp "$picture_path" "$remote_user@$remote_host:$remote_dir/"
                        fi
                fi
        done
done



