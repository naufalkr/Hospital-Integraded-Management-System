<?php

$host = 'localhost';
$dbname = 'db55';
$dbusername = "root";
$dbpassword = "Boyolali394";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;", $dbusername, $dbpassword);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    die();
}

// Path: includes/dbhinc.php