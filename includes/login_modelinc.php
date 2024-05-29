<?php

declare(strict_types= 1);
function get_user_pasien(object $pdo,string $NIK,string $role){
    $query = "SELECT * FROM {$role} WHERE NIK = :NIK";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":NIK", $NIK);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}

function get_user_tenagamedis(object $pdo,string $tenagamedis_id,string $role){
    $query = "SELECT * FROM {$role} WHERE tenagamedis_id = :tenagamedis_id";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":tenagamedis_id", $tenagamedis_id);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}