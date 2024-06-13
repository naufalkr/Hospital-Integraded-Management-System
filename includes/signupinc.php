<?php

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    require_once 'dbhinc.php';
    require_once 'signup_modelinc.php';
    require_once 'signup_controllerinc.php';
    require_once 'config_sessioninc.php';

    // Check if the form is from signup_tenagamedis.php
    if (isset($_POST["tenagamedis_id"])) {
        $tenagamedis_id = $_POST["tenagamedis_id"];
        $password = $_POST["password"];
        $email = $_POST["email"];
        $nama_tenagamedis = $_POST["nama_tenagamedis"];
        $spesialisasi = $_POST["spesialisasi"];
        $jenis_kelamin = $_POST["jenis_kelamin"];
        $no_telepon_tenagamedis = $_POST["no_telepon_tenagamedis"];

        // Error handler
        $errors = [];

        if (is_input_empty($tenagamedis_id, $password, $email)) {
            $errors["empty_input"] = "Fill in all fields!";
        }

        // if (is_email_invalid($email)) {
        //     $errors["invalid_email"] = "Invalid email used!";
        // }

        if (is_tenagamedis_id_taken($pdo, $tenagamedis_id)) {
            $errors["tenagamedis_id_taken"] = "ID already taken!";
        }

        // if (is_email_registered($pdo, $email)) {
        //     $errors["email_used"] = "Email already registered!";
        // }

        if ($errors) {
            $_SESSION["errors_signup"] = $errors;
            header("Location: ../signup_tenagamedis.php");
            die();
        }

        create_user_tenagamedis($pdo, $tenagamedis_id, $password, $email, $nama_tenagamedis, $spesialisasi, $jenis_kelamin, $no_telepon_tenagamedis);

        header("Location: ../index.php?signup=success");

    } else if (isset($_POST["NIK"])) {
        // Form is from signup.php (patient)
        $NIK = $_POST["NIK"];
        $password = $_POST["password"];
        $email = $_POST['email'];
        $nama_pasien = $_POST['nama_pasien'];
        $Tanggal_Lahir = $_POST['Tanggal_Lahir'];
        $alamat = $_POST['alamat'];
        $tinggi = $_POST['tinggi'];
        $berat_badan = $_POST['berat_badan'];
        $golongan_darah = $_POST['golongan_darah'];
        $alergi = $_POST['alergi'];
        $no_telepon_pasien = $_POST['no_telepon_pasien'];
        $jenis_kelamin = $_POST['jenis_kelamin'];

        // Error handler
        $errors = [];

        if (is_input_empty($NIK, $password, $email)) {
            $errors["empty_input"] = "Fill in all fields!";
        }

        if (is_email_invalid($email)) {
            $errors["invalid_email"] = "Invalid email used!";
        }

        if (is_NIK_taken($pdo, $NIK)) {
            $errors["NIK_taken"] = "NIK already taken!";
        }

        if (is_email_registered($pdo, $email)) {
            $errors["email_used"] = "Email already registered!";
        }

        if ($errors) {
            $_SESSION["errors_signup"] = $errors;
            header("Location: ../signup.php");
            die();
        }

        create_user_pasien($pdo, $NIK, $password, $email, $nama_pasien, $Tanggal_Lahir, $alamat, $tinggi, $berat_badan, $golongan_darah, $alergi, $no_telepon_pasien, $jenis_kelamin);

        header("Location: ../index.php?signup=success");
    }

    $pdo = null;
    $stmt = null;
    die();

} else {
    header("Location: ../signup.php");
    die();
}
?>
