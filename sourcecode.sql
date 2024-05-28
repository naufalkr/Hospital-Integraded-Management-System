create table matapelajaran
(
    mapel_id     int auto_increment
        primary key,
    mapel        varchar(255) null,
    kelas        varchar(20)  null,
    pdfs         mediumblob   null,
    videos       varchar(255) null,
    latihan_soal mediumblob   null
);

create table users
(
    id       int auto_increment
        primary key,
    -- NIK char(16) not null,
    username varchar(100) not null,
    password varchar(100) not null,
    email    varchar(100) not null,
    usertype varchar(20)  null,
    nama_pasien varchar(100) not null,
    alamat    varchar(100) not null,
    no_telepon_pasien varchar(100) not null,
    jenis_kelamin varchar(100) not null
);

create table tenaga_medis
(
    id       int auto_increment
        primary key,
    -- NIK char(16) not null,
    username varchar(100) not null,
    password varchar(100) not null,
    email    varchar(100) not null,
    usertype varchar(20)  null,
    nama_pasien varchar(100) not null,
    alamat    varchar(100) not null,
    no_telepon_pasien varchar(100) not null,
    jenis_kelamin varchar(100) not null
);
-- CREATE TABLE Pasien (
--     NIK_Pasien VARCHAR(10) PRIMARY KEY,
--     Nama_Pasien VARCHAR(100),
--     Tanggal_Lahir DATE,
--     Alamat VARCHAR(255),
--     No_Telepon_Pasien VARCHAR(15),
--     Email VARCHAR(100),
--     Jenis_Kelamin ENUM('Laki-laki', 'Perempuan')
-- );

