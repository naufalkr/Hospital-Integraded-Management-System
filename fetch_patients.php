<?php
include_once 'includes/dbhinc.php'; // Sesuaikan dengan file koneksi database Anda

if (isset($_GET['tenagamedis_id'])) {
    $tenagamedis_id = $_GET['tenagamedis_id'];

    // Query untuk mengambil pasien yang terkait dengan dokter
    $query = $pdo->prepare("SELECT  * FROM pasien P JOIN riwayat R ON P.NIK = R.NIK WHERE R.tenagamedis_id = :tenagamedis_id  ORDER BY nama_pasien");
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
