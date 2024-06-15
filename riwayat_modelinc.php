<?php

declare(strict_types= 1);

function set_riwayat(object $pdo, int $riwayat_id, int $NIK,int $rumahsakit_id,int $tenagamedis_id,string $tanggal_riwayat,string $jenis_layanan, string $keterangan_penyakit){
    $query = "INSERT INTO riwayat(riwayat_id, NIK, rumahsakit_id, tenagamedis_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit) 
              VALUES (:riwayat_id, :NIK, :rumahsakit_id, :tenagamedis_id, :tanggal_riwayat, :jenis_layanan, :keterangan_penyakit)";
    $stmt = $pdo->prepare($query);

    $options = [
        'cost' => 12
    ];

    $stmt->bindParam(":riwayat_id", $riwayat_id);
    $stmt->bindParam(":NIK", $NIK);
    $stmt->bindParam(":rumahsakit_id", $rumahsakit_id);
    $stmt->bindParam(":tenagamedis_id", $tenagamedis_id);
    $stmt->bindParam(":tanggal_riwayat", $tanggal_riwayat);
    $stmt->bindParam(":jenis_layanan", $jenis_layanan);
    $stmt->bindParam(":keterangan_penyakit", $keterangan_penyakit);
    // $stmt->bindParam(":nama_pasien", $nama_pasien);
    
    $stmt->execute();
}
