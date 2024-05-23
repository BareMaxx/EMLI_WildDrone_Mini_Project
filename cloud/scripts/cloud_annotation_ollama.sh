#!/bin/bash

directory_path="$1"
script_dir=$(dirname "$(readlink -f "$0")")

echo "Test1: $directory_path"
for file_path in "$directory_path"/*; do
	echo "Test2: $file_path"
        if [[ "$file_path" == *"json"* ]]; then
                picture_path="${file_path%.*}.jpg"
                json_file="$file_path"

                if jq -e '.["Annotation"] | has("Source")' "$json_file" >/dev/null; then
                        echo "Test3"
			continue
                else
                        response=$(sudo ollama run llava:7b "Describe $picture_path")
                        echo "Test of response: $response"
                        annotation_text="$response"

                        new_data=$(jq -n --arg source "llava:7b" --arg text "$annotation_text" \
                        '{"Annotation": {"Source": $source, "Text": $text}}')

			jq --argjson new_data "$new_data" '. + $new_data' "$json_file" > "tmp.$$.json" && mv "tmp.$$.json" "$json_file"
                fi
        fi
done


sudo mkdir -p $script_dir/../../data/cloud_json/
sudo cp "$directory_path"/*.json $script_dir/../../data/cloud_json/
