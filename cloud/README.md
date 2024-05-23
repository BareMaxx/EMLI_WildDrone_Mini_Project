# Guide to Cloud files

## cloud_annotation_ollama.sh
This shell script file needs a destination for the directory that contains the downloads files on the drone.
The file ends by creating a folder in data called cloud_json that contains the updated json files.
It can be used like this if you are in the folder cloud/scripts:
sudo ./cloud_annotation_ollama.sh ../../data/pictures/2024-05-23

## upload_json_files_to_repo.sh
This script pushes the json files. To run the script do the following:
sudo ./upload_json_files_to_repo.sh "you@github-email.com" "GitHub-name"

### If it complains about lack of permission because it finds the shell script sus
You need to give the repo special permission:
sudo git config --global --add safe.directory EMLI_WildDrone_Mini_Project



