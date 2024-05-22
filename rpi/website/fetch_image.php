<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$directory = '/home/jeinere/mini_project/EMLI_WildDrone_Mini_Project/data/pictures';

if (isset($_GET['path'])) {
    $path = $_GET['path'];
    $fullPath = realpath($directory."/".$path);

    if (is_file($fullPath)) {
        $mimeType = mime_content_type($fullPath);
        header('Content-Type: '.$mimeType);
        readfile($fullPath);
        exit;
    } else {
        http_response_code(404);
        echo "File not found.";
        exit;
    }
} else {
    http_response_code(400);
    echo "No file specified.";
    exit;
}
?>
