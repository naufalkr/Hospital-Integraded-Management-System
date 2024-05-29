<?php

declare(strict_types= 1);

function is_input_empty(string $NIK,string $password,string $role){
    if(empty($NIK) || empty($password) || empty($role)){
        return true;
    } else{
        return false;
    }
}

function is_NIK_invalid(bool|array $result){
    if(!$result){
        return true;
    } else{
        return false;
    }
}

function is_password_invalid(string $password, string $hashedPassword){
    if(!password_verify($password, $hashedPassword)){
        return true;
    } else{
        return false;
    }
}

