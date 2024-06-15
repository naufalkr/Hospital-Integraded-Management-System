<?php
// process_riwayat.php

include_once 'includes/dbhinc.php'; // Adjust path as necessary

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validate and sanitize input (for security, not shown here)
    
    $nik = $_POST['nik'];
    $dokter = $_POST['dokter'];
    $waktu = $_POST['waktu'];
    $jenisLayanan = $_POST['jenisLayanan'];
    $keterangan = $_POST['keterangan'];

    // Example: Insert into riwayat table
    $query = "INSERT INTO riwayat (NIK, rumahsakit_id, tenagamedis_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
              VALUES (:nik, :rumahsakit_id, :tenagamedis_id, :tanggal_riwayat, :jenis_layanan, :keterangan)";

    $stmt = $pdo->prepare($query);
    $stmt->execute([
        'nik' => $nik,
        'rumahsakit_id' => $rumahsakit_id, // Ensure $rumahsakit_id is defined in your script
        'tenagamedis_id' => $dokter,
        'tanggal_riwayat' => $waktu,
        'jenis_layanan' => $jenisLayanan,
        'keterangan' => $keterangan
    ]);

    // Optionally, handle success or errors
    // Example:
    if ($stmt->rowCount() > 0) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'error' => 'Failed to insert medical history.']);
    }
}
?>
