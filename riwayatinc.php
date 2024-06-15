<?php

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    require_once 'includes/dbhinc.php';
    require_once 'riwayat_modelinc.php';
    require_once 'riwayat_controllerinc.php';
    require_once 'includes/config_sessioninc.php';

        // Form is from signup.php (patient)
        $riwayat_id = mt_rand(1000, 9999); // Menghasilkan angka random antara 1000 dan 9999
        $NIK = $_POST["NIK"];
        $rumahsakit_id = $_POST['rumahsakit_id'];
        $tenagamedis_id = $_POST['tenagamedis_id'];
        $tanggal_riwayat = $_POST['tanggal_riwayat'];
        $jenis_layanan = $_POST['jenis_layanan'];
        $keterangan_penyakit = $_POST['keterangan_penyakit'];
        

        create_user_riwayat($pdo, $riwayat_id, $NIK, $rumahsakit_id, $tenagamedis_id, $tanggal_riwayat, $jenis_layanan, $keterangan_penyakit);

        header("Location: ../dashboard-rs.php?content=Tambah Riwayat");
    }

    $pdo = null;
    $stmt = null;
    die();

?>
