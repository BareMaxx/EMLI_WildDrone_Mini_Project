<!DOCTYPE html>
<html>
<head>
    <title>Wild Life Cam</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
</head>
<body>
    <h1>Welcome to the local webpage of the wild life camera</h1>
    <p>The log file can be found here: <a href="/show_log.php">link to logfile</a></p>
    <h2>Images and metadata on the camera:</h2><br/>
    <?php
    $directory = '/home/jeinere/mini_project/EMLI_WildDrone_Mini_Project/data/pictures';

    if (is_dir($directory)) {
        $directoryHandle = opendir($directory);
        
        while (false !== ($folder = readdir($directoryHandle))) {
            if (!($folder == "." || $folder == "..")) {
                $subDirectory = $directory."/".$folder;
                if (is_dir($subDirectory)) {
                    $subDirectoryHandle = opendir($subDirectory);
                    echo "<div style=\"display:flex; flex-direction:column;\">";
                    while (false !== ($file = readdir($subDirectoryHandle))) {
                        if (str_ends_with($file, ".jpg")) {
                            $fileName = explode(".", $file);
                            echo "<h3>Image and metadata file: ".$fileName[0]."</h3>";
                            echo "<div style=\"display:flex; flex-direction:row;\">";
                            $imagePath = $folder."/".$file;
                            $url = "/fetch_image.php?path=".urlencode($imagePath);
                            echo "<img style=\"max-width: 550px\" src=\"$url\" /><br>";

                            $metadataFile = $fileName[0].".json";
                            $metadataPath = $folder."/".$metadataFile;
                            $url = "/fetch_metadata.php?path=".urlencode($metadataPath);
                            $fullPath = realpath($directory."/".$metadataPath);
                            
                            if (is_file($fullPath)) {

                                $metadata = file_get_contents($fullPath);
                                $jsonData = json_decode($metadata, true);
                                echo "<pre>".print_r($jsonData, true)."</pre>";
                            }

                            echo "</div>";
                        } 
                    }
                    echo "</div>";
                    closedir($subDirectoryHandle);
                }
            }
        }

        closedir($directoryHandle);
    }
    ?>
</body>
</html>