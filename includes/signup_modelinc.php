<?php

declare(strict_types= 1);

function get_NIK(object $pdo, string $NIK){
    $query = "SELECT NIK FROM pasien WHERE NIK = :NIK;";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":NIK", $NIK);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}

function get_tenagamedis_id(object $pdo, int $tenagamedis_id){
    $query = "SELECT tenagamedis_id FROM tenaga_medis WHERE tenagamedis_id = :tenagamedis_id;";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":tenagamedis_id", $tenagamedis_id);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}


function get_email_pasien(object $pdo, string $email){
    $query = "SELECT email FROM pasien WHERE email = :email;";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":email", $email);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}

function get_email_tenagamedis(object $pdo, string $email){
    $query = "SELECT email FROM tenaga_medis WHERE email = :email;";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":email", $email);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}

function set_user_pasien(object $pdo, string $NIK, string $password, string $email, string $nama_pasien,  string $Tanggal_Lahir, string $alamat, int $tinggi, int $berat_badan, string $golongan_darah, string $alergi, string $no_telepon_pasien, string $jenis_kelamin){
    $query = "INSERT INTO pasien(NIK, password, email, nama_pasien, Tanggal_Lahir, alamat, tinggi, berat_badan, golongan_darah, alergi, no_telepon_pasien, jenis_kelamin) 
              VALUES (:NIK, :password, :email, :nama_pasien, :Tanggal_Lahir, :alamat, :tinggi, :berat_badan, :golongan_darah, :alergi, :no_telepon_pasien, :jenis_kelamin)";
    $stmt = $pdo->prepare($query);

    $options = [
        'cost' => 12
    ];
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT, $options);

    $stmt->bindParam(":NIK", $NIK);
    $stmt->bindParam(":password", $hashedPassword);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":nama_pasien", $nama_pasien);
    $stmt->bindParam(":Tanggal_Lahir", $Tanggal_Lahir);
    $stmt->bindParam(":alamat", $alamat);
    $stmt->bindParam(":tinggi", $tinggi);
    $stmt->bindParam(":berat_badan", $berat_badan);
    $stmt->bindParam(":golongan_darah", $golongan_darah);
    $stmt->bindParam(":alergi", $alergi);
    $stmt->bindParam(":no_telepon_pasien", $no_telepon_pasien);
    $stmt->bindParam(":jenis_kelamin", $jenis_kelamin);
    // $stmt->bindParam(":nama_pasien", $nama_pasien);
    
    $stmt->execute();
}

function set_user_tenagamedis(object $pdo, int $tenagamedis_id, string $password, string $email, string $nama_tenagamedis, string $spesialisasi, string $jenis_kelamin, string $no_telepon_tenagamedis){
    $query = "INSERT INTO tenaga_medis (tenagamedis_id, password, email, nama_tenagamedis, spesialisasi, jenis_kelamin, no_telepon_tenagamedis) VALUES (:tenagamedis_id, :password, :email, :nama_tenagamedis, :spesialisasi, :jenis_kelamin, :no_telepon_tenagamedis)";
    $stmt = $pdo->prepare($query);

    $options = [
        'cost' => 12
    ];
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT, $options);

    $stmt->bindParam(":tenagamedis_id", $tenagamedis_id);
    $stmt->bindParam(":password", $hashedPassword);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":nama_tenagamedis", $nama_tenagamedis);
    $stmt->bindParam(":spesialisasi", $spesialisasi);
    $stmt->bindParam(":jenis_kelamin", $jenis_kelamin);
    $stmt->bindParam(":no_telepon_tenagamedis", $no_telepon_tenagamedis);

    $stmt->execute();
}

// set_user($pdo, $NIK,$password,$email,$nama_pasien,$alamat,$no_telepon_pasien,$jenis_kelamin);