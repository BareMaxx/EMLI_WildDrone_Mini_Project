<!DOCTYPE html>
<html>
<head>
    <title>Wild Life Cam Log</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
</head>
<body>
    <h1>Welcome to the local webpage of the wild life camera, this is the log file of the camera</h1>
    <p>Go back to the pictures and metadata by clicking <a href="/wildlifecam.php">here</a>.</p>
<?php
    $logfilePath = '/home/jeinere/mini_project/EMLI_WildDrone_Mini_Project/data/logger/syslog.log';
    $fullPath = realpath($logfile);

    $file = fopen($fullPath, "r");
    while(false !== ($line = fgets($file))) {
        echo $line."<br>";
    }
    fclose($file);  
?>
</body>
</html>