<?php
include_once 'includes/dbhinc.php'; // Sesuaikan dengan file koneksi database Anda

if (isset($_GET['riwayat_id'])) {
    $riwayat_id = $_GET['riwayat_id'];

    // Query untuk mengambil pasien yang terkait dengan dokter
    $query = $pdo->prepare("SELECT * FROM riwayat WHERE riwayat_id = :riwayat_id");
    $query->execute(['riwayat_id' => $riwayat_id]);
    $patients = $query->fetchAll(PDO::FETCH_ASSOC);
    
    
    // Mengembalikan respons dalam format JSON
    header('Content-Type: application/json');
    echo json_encode($patients);
} else {
    // Menangani permintaan yang tidak valid
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request']);
}
?>
