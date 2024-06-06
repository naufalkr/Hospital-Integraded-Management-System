<?php
include_once 'includes/config_sessioninc.php';
include_once 'includes/dbhinc.php'; // Include the database connection file

header('Content-Type: application/json');

// Get the POST data
$data = json_decode(file_get_contents('php://input'), true);
$nik = $data['nik'];

$query = $pdo->prepare("SELECT * FROM pasien WHERE nik = :nik");
$query->execute(['nik' => $nik]);
$patient = $query->fetch(PDO::FETCH_ASSOC);

if ($patient) {
    echo json_encode(['success' => true, 'patient' => $patient]);
} else {
    echo json_encode(['success' => false]);
}
?>
