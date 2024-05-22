# Wild life camera website

## How to
This directory contains four files:
- wildlifecam.php
- show_log.php
- fetch_image.php
- README.md

The three php files are the files used for the website of the wild life camera.
The website on the camera is an Apache2 website. The three php files should therefore be placed in the  ```/var/www/html``` folder. 

Ensure that Apache2 is up and running. 

The paths to the pictures, metadata, and logfiles are hardcoded inside the php files.

The folders which the PHP files need to access and traverse though should have the following permissions:
Folders for traverse:
```chmod o+x path```
Folders and files for read:
```chmod -R 755 path```