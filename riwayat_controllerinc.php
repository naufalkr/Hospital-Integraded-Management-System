<?php

declare(strict_types= 1);


function create_user_riwayat(object $pdo, int $riwayat_id, int $NIK,int $rumahsakit_id,int $tenagamedis_id,int $obat_id,string $tanggal_riwayat,string $jenis_layanan, string $keterangan_penyakit){
    // set_user($pdo, $NIK, $password, $email);
    set_riwayat($pdo, $riwayat_id, $NIK, $rumahsakit_id, $tenagamedis_id, $obat_id, $tanggal_riwayat, $jenis_layanan, $keterangan_penyakit);
}
