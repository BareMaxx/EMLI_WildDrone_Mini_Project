#!/bin/bash

echo "Initiate download..."

# Ensure that the wildlife_downloads folder exists
script_dir=$(dirname "$(readlink -f "$0")")
sudo mkdir -p $script_dir/wildlife_downloads
sudo chmod -R 777 $script_dir/wildlife_downloads

target_dir=$script_dir/wildlife_downloads
drone_id="$1"

# Settings for ssh into the Raspberry Pi
client_ip="10.0.0.10"
client_user="jeinere"

echo "Getting file paths"
file_paths=$(ssh $client_user@$client_ip bash mini_project/EMLI_WildDrone_Mini_Project/rpi/scripts/get_all_pictures_paths.sh)
echo "Done getting file paths"

echo "$file_paths" | jq -c '.[]' | while IFS= read -r item; do
	picture_path=$(echo "$item" | jq -r '.picture_path' 2>/dev/null)
	file_path=$(echo "$item" | jq -r '.file_path' 2>/dev/null)

	if [ "$picture_path" == "null" ] || [ "$picture_path" == "" ] || [ "$file_path" == "null" ] || [ "$file_path" == "" ]; then
		# echo "Parsing failed, skipping element"
		continue
	fi

	# echo "Picture path: $picture_path"
	# echo "JSON path: $file_path"

	# Download the picture and json file
	scp $client_user@$client_ip:"$picture_path" "$target_dir"
	scp $client_user@$client_ip:"$file_path" "$target_dir"

	ssh -n $client_user@$client_ip bash mini_project/EMLI_WildDrone_Mini_Project/rpi/scripts/file_downloaded.sh "$drone_id" "$file_path"
done

echo "Finished downloading"
