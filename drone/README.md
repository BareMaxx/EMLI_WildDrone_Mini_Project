## Important
In order to ensure that the computer running the drone script ./scripts/droneFlight.sh, has all the libraries required (mysql, wireless-tools, jq), the user has to manually run the script ./scripts/runPrerequisites.sh to install it.

## Scripts
The "master" script running on the drone is the ./scripts/droneFlight.sh. This script utilizes all the other scripts (apart from the ./scripts/runPrerequisites.sh script).
Start the drone by running bash droneFlight.sh.

./scripts/initiateDownload.sh is used to download the pictures and metadata files from the drone. The script is automatically run by the droneFlight script as a background service. The initiateDownload script first requests all the images and metadata files from the wildlife camera. The wildlife camera only returns the path of the files that has not already been downloaded. The initiateDownload script then goes through each pair of image and metadata file and scp (downloads) the files and then makes a SSH call to a script on the wildlife camera which marks the newly downloaded files as downloaded.
Next time the drone connects to the same camera, it will perform the same actions again and therefore continue to download the files it's missing and the new ones created while it was disconnected.

./scripts/setupDatabase.sh is used to create the MySQL database and the table WifiSignalTable. The droneFlight script calls the function insert_row() every 0.1 seconds to log the wifi signal.

./scripts/timeSync.sh is used to set the Chrony config file on the wildlife camera to connect to the specific drone's Chrony server. Chrony is used to sync the wildlife camera's date and time to the date and time of the drone. The Chrony server on the drone uses the drone's own date and time, so if it's incorrect, the date and time on the wildlife camera will be incorrect too.

./scripts/wifiConnect.sh is used to disconnect the drone from the current wifi and searching for wildlife camera wifi access points. It keeps searching every 0.5 seconds until it finds one and connects.

./scripts/wifiStats.sh is used to get the current stats of the wifi connection. This script is used by the droneFlight script to insert into the local MySQL database.
