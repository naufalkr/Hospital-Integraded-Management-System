<?php
include_once 'includes/dbhinc.php'; // Sesuaikan dengan file koneksi database Anda

if (isset($_GET['tenagamedis_id'])) {
    $tenagamedis_id = $_GET['tenagamedis_id'];

    // Query untuk mengambil pasien yang terkait dengan dokter
    $query = $pdo->prepare("SELECT p.*
        FROM (
            SELECT DISTINCT p.NIK
            FROM pasien p
            JOIN riwayat r ON p.NIK = r.NIK
            WHERE r.tenagamedis_id = :tenagamedis_id
        ) AS distinct_nik
        JOIN pasien p ON p.NIK = distinct_nik.NIK
        ORDER BY p.NIK;
    ");
    $query->execute(['tenagamedis_id' => $tenagamedis_id]);
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
