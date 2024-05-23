## Scripts
The "master" script running on the drone is the ./scripts/droneFlight.sh. This script utilizes all the other scripts (apart from the ./scripts/runPrerequisites.sh script).
Start the drone by running bash droneFlight.sh.

### Important
In order to ensure that the computer running the drone script ./scripts/droneFlight.sh, has all the libraries required (mysql, wireless-tools), the user has to manually run the script ./scripts/runPrerequisites.sh to install it.

./scripts/download_pictures.sh is used to download files from where it is run from to an external host.
To use the script the drone should SSH into the Raspberry PI and then run the sript on the PI.
To run the script a remote user, host and target directory should be defined.

Example:
sudo ./scripts/download_pictures.sh "username" "host" "/path/to/directory" 

./scripts/setupDatabase.sh is used to create the MySQL database and the table WifiSignalTable. The droneFlight script calls the function insert_row() every 0.1 seconds to log the wifi signal.

./scripts/timeSync.sh is used to set the Chrony config file on the wildlife camera to connect to the specific drone's Chrony server. Chrony is used to sync the wildlife camera's date and time to the date and time of the drone. The Chrony server on the drone uses the drone's own date and time, so if it's incorrect, the date and time on the wildlife camera will be incorrect too.

./scripts/wifiConnect.sh is used to disconnect the drone from the current wifi and searching for wildlife camera wifi access points. It keeps searching every 0.5 seconds until it finds one and connects.

./scripts/wifiStats.sh is used to get the current stats of the wifi connection. This script is used by the droneFlight script to insert into the local MySQL database.
