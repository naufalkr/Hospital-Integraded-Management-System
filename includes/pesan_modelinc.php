<?php

declare(strict_types=1);

function input_message(object $pdo,?string $pengirim, ?string $penerima, ?string $pesan){
    $query = "INSERT INTO pesan (pengirim, penerima, berita) VALUES (:pengirim, :penerima, :pesan)";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(":pengirim", $pengirim);
    $stmt->bindParam(":penerima", $penerima);
    $stmt->bindParam(":pesan", $pesan);
    $stmt->execute();
}