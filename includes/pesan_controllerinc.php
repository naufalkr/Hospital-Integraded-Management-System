<?php

declare(strict_types= 1);

function is_input_empty(string $pengirim,string $penerima, string $pesan){
    if(empty($pengirim) || empty($penerima) || empty($pesan)) {
        return true;
    } else{
        return false;
    }
}