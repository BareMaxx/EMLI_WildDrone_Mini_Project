## How to use motion detection and take pictures

sudo apt install python3-opencv

./rpi/scripts/take_photo.sh is used to take pictures for Time and External. It is important to pass either "Time" or "External" as a parameter (e.g., sudo ./take_photo.sh "Time").

./rpi/scripts/motion_detection.sh is used to compare to pictures for motion. It takes a new picture and compare to previous picture every 3-4 seconds. The two pictures used for comparison is saved in ./rpi/scripts/pictures
Motion detection only stores the latest picture permanently if motion is detected.

take_photo.sh and motion_detection.sh will place the pictures in ./data/pictures/
