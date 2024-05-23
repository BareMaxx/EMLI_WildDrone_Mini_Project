#!/bin/bash

directory_path="$1"

script_dir=$(dirname "$(readlink -f "$0")")

for file_path in "$directory_path"/*; do
	if [[ "$file_path" == *"json"* ]]; then
		picture_path="${file_path%.*}.jpg"
 		json_file="$file_path"

		response=$(sudo ollama run llava "Describe $picture_path")
		echo "Test of response: $response"
		annotation_text="$response"

		new_data=$(jq -n --arg source "Llama3" --arg text "$annotation_text" \
        	    '{"Annotation": {"Source": $source, "Text": $text}}')

		jq --argjson new_data "$new_data" '. + $new_data' "$json_file" > tmp.$$>
	fi
done

sudo mkdir -P $script_dir/../../data/cloud_json/
sudo cp "$directory_path"/*.json $script_dir/../../data/cloud_json/
