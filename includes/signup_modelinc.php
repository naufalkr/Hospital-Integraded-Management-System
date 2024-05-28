<?php

declare(strict_types= 1);

function get_username(object $pdo, string $username){
    $query = "SELECT username FROM users WHERE username = :username;";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":username", $username);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}


function get_email(object $pdo, string $email){
    $query = "SELECT email FROM users WHERE email = :email;";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":email", $email);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}

function set_user(object $pdo, string $username,string $password,string $email,string $nama_pasien,string $alamat,string $no_telepon_pasien,string $jenis_kelamin){
    $query = "INSERT INTO users(username, password, email, nama_pasien, alamat, no_telepon_pasien, jenis_kelamin) VALUES (:username, :password, :email, :nama_pasien, :alamat, :no_telepon_pasien, :jenis_kelamin)";
    $stmt = $pdo->prepare($query);

    $options = [
        'cost' => 12
    ];
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT, $options);

    $stmt->bindParam(":username", $username);
    $stmt->bindParam(":password", $hashedPassword);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":nama_pasien", $nama_pasien);
    $stmt->bindParam(":alamat", $alamat);
    $stmt->bindParam(":no_telepon_pasien", $no_telepon_pasien);
    $stmt->bindParam(":jenis_kelamin", $jenis_kelamin);
    // $stmt->bindParam(":nama_pasien", $nama_pasien);
    
    $stmt->execute();
}


// set_user($pdo, $username,$password,$email,$nama_pasien,$alamat,$no_telepon_pasien,$jenis_kelamin);