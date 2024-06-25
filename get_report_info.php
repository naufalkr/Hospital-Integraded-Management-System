<?php
// get_report_info.php

// Lakukan koneksi ke database
include_once 'includes/config_sessioninc.php';
include_once 'includes/login_viewinc.php';
include_once 'includes/dbhinc.php'; // Include the database connection file


// Ambil id dari parameter URL
$reportId = $_GET['id'];

// Query untuk mengambil informasi riwayat dari database berdasarkan id
$query = $pdo->prepare("SELECT riwayat.tanggal_riwayat, tenaga_medis.nama_tenagamedis, rumah_sakit.nama_rumahsakit, obat.nama_obat, riwayat.keterangan_penyakit 
                        FROM riwayat 
                        INNER JOIN tenaga_medis ON riwayat.tenagamedis_id = tenaga_medis.tenagamedis_id 
                        INNER JOIN obat ON riwayat.obat_id = obat.obat_id 
                        INNER JOIN rumah_sakit ON riwayat.rumahsakit_id = rumah_sakit.rumahsakit_id 
                        WHERE riwayat.riwayat_id = :id");
$query->execute(['id' => $reportId]);
$reportInfo = $query->fetch(PDO::FETCH_ASSOC);

// Kembalikan data dalam format JSON
echo json_encode($reportInfo);
?>
