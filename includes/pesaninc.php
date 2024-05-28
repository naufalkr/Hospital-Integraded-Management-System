<?php

if($_SERVER["REQUEST_METHOD"] === "POST"){
    $pengirim = $_POST["pengirim"];
    $penerima = $_POST["penerima"];
    $pesan = $_POST["pesan"];

    try {
        require_once 'dbhinc.php';
        require_once 'pesan_controllerinc.php';
        require_once 'pesan_modelinc.php'; 

        input_message($pdo, $pengirim, $penerima, $pesan);

        //login success
        header("Location: ../dashboard.php?message=sent");
        $pdo = null;
        $stmt = null;

        die();
    } catch (PDOException $e) {
        die("Query failed: " . $e->getMessage());
    }
} else {
    header("Location: ../dashboard.php");
    die();
}