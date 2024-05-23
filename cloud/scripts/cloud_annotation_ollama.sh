#!/bin/bash

directory_path="$1"
LLAMA3_URL="http://127.0.0.1:11434/annotate"

for file_path in "$directory_path"/*; do
    if [[ "$file_path" == *"json"* ]]; then
        picture_path="${file_path%.*}.jpg"
        json_file="$file_path"

        response=$(ollama run llama3 --verbose < "$picture_path")
        echo "Test of response: $response"
	annotation_text="$response"

        new_data=$(jq -n --arg source "Llama3" --arg text "$annotation_text" \
                    '{"Annotation": {"Source": $source, "Text": $text}}')

        jq --argjson new_data "$new_data" '. + $new_data' "$json_file" > tmp.$$.json && mv tmp.$$.json "$json_file"
    fi
done

