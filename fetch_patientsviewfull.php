<?php
include_once 'includes/dbhinc.php'; // Sesuaikan dengan file koneksi database Anda

if (isset($_GET['NIK'])) {
    $NIK = $_GET['NIK'];

    // Query untuk mengambil pasien yang terkait dengan dokter
    $query = $pdo->prepare("SELECT * FROM riwayat WHERE NIK = :NIK");
    $query->execute(['NIK' => $NIK]);
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
