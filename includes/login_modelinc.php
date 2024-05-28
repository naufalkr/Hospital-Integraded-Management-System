<?php

declare(strict_types= 1);
function get_user(object $pdo,string $username,string $role){
    $query = "SELECT * FROM {$role} WHERE username = :username";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":username", $username);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result;
}