## Scripts
./scripts/download_pictures.sh is used to download files from where it is run from to an external host.
To use the script the drone should SSH into the Raspberry PI and then run the sript on the PI.
To run the script a remote user, host and target directory should be defined.

Example:
sudo ./scripts/download_pictures.sh "username" "host" "/path/to/directory" 
