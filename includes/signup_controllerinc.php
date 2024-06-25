<?php

declare(strict_types= 1);

function is_input_empty(string $NIK,string $password,string $email){
    if(empty($NIK) || empty($password) || empty($email)){
        return true;
    } else{
        return false;
    }
}

function is_email_invalid(string $email){
    if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
        return true;
    } else{
        return false;
    }
}

function is_NIK_taken(object $pdo, string $NIK){
    if(get_NIK($pdo,$NIK)){
        return true;
    } else{
        return false;
    }
}

function is_tenagamedis_id_taken($pdo, $tenagamedis_id) {
    $stmt = $pdo->prepare("SELECT tenagamedis_id FROM tenaga_medis WHERE tenagamedis_id = ?");
    $stmt->execute([$tenagamedis_id]);
    return $stmt->fetch() ? true : false;
}

function is_email_registered(object $pdo, string $email){
    if(get_email_pasien($pdo, $email)){
        return true;
    } else{
        return false;
    }
}

function create_user_pasien(object $pdo, string $NIK,string $password,string $email,string $nama_pasien, string $Tanggal_Lahir, string $alamat, int $tinggi, int $berat_badan, string $golongan_darah, string $alergi, string $no_telepon_pasien,string $jenis_kelamin){
    // set_user($pdo, $NIK, $password, $email);
    set_user_pasien($pdo, $NIK,$password,$email,$nama_pasien,$Tanggal_Lahir,$alamat,$tinggi,$berat_badan,$golongan_darah,$alergi,$no_telepon_pasien,$jenis_kelamin);
}

// $stmt->bindParam(":Tanggal_Lahir", $Tanggal_Lahir);
//     $stmt->bindParam(":alamat", $alamat);
//     $stmt->bindParam(":tinggi", $tinggi);
//     $stmt->bindParam(":berat_badan", $berat_badan);
//     $stmt->bindParam(":golongan_darah", $golongan_darah);
//     $stmt->bindParam(":alergi", $alergi);

function create_user_tenagamedis(object $pdo, int $tenagamedis_id, int $rumahsakit_id,string $password,string $email,string $nama_tenagamedis,string $spesialisasi,string $jenis_kelamin,string $no_telepon_tenagamedis){
    // set_user($pdo, $NIK, $password, $email);
    set_user_tenagamedis($pdo, $tenagamedis_id, $rumahsakit_id, $password, $email, $nama_tenagamedis, $spesialisasi, $jenis_kelamin, $no_telepon_tenagamedis);
}