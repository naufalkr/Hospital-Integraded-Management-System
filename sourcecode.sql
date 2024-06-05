	create database if not exists db37;

	use db37;
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

		create table pasien
		(
			id     int,
			NIK varchar(100) primary key,
			password varchar(100) not null,
			email    varchar(100) not null,
			usertype varchar(20)  null,
			nama_pasien varchar(100) not null,
			Tanggal_Lahir DATE,
			alamat    varchar(100) not null,
			tinggi int,
			berat_badan int,
			golongan_darah varchar(5),
			alergi varchar(100),
			no_telepon_pasien varchar(100) not null,
			jenis_kelamin varchar(100) not null
		);
		
		CREATE TABLE Rumah_Sakit (
			rumahsakit_id INT PRIMARY KEY,
			nama_rumahsakit VARCHAR(100),
			alamat VARCHAR(255),
			no_telepon VARCHAR(15),
			kota VARCHAR(100)
		);


		create table tenaga_medis
		(
			id     int,
			tenagamedis_id INT primary key,
			rumahsakit_id INT,
			password varchar(100) not null,
			email    varchar(100) not null,
			usertype varchar(20)  null,
			nama_tenagamedis varchar(100) not null,
			spesialisasi    varchar(100) not null,
			jenis_Kelamin varchar(100) not null,
			no_telepon_tenagamedis varchar(100) not null,
			FOREIGN KEY (rumahsakit_id) REFERENCES rumah_sakit(rumahsakit_id)
		);

		

		CREATE TABLE riwayat (
			riwayat_id INT PRIMARY KEY,
			NIK VARCHAR(10),
			rumahsakit_id INT,
			tenagamedis_id INT,
			tanggal_riwayat DATE,
			jenis_layanan VARCHAR(100),
			keterangan_penyakit VARCHAR(255),
			FOREIGN KEY (NIK) REFERENCES pasien(NIK),
			FOREIGN KEY (rumahsakit_id) REFERENCES rumah_sakit(rumahsakit_id),
			FOREIGN KEY (tenagamedis_id) REFERENCES tenaga_medis(tenagamedis_id)
		);

		-- Tabel obat
		CREATE TABLE obat (
			obat_id INT PRIMARY KEY,
			nama_obat VARCHAR(100),
			deskripsi VARCHAR(255)
		);



	ALTER TABLE Pasien
	ADD COLUMN Usia INT,
	ADD COLUMN Kategori VARCHAR(20);


	DELIMITER //

	CREATE FUNCTION calculate_age_category(
		p_birth_date DATE
	)
	RETURNS VARCHAR(20)
	DETERMINISTIC
	BEGIN
		DECLARE age INT;
		DECLARE category VARCHAR(20);

		SET age = TIMESTAMPDIFF(YEAR, p_birth_date, CURDATE());
		
		IF age < 18 THEN
			SET category = 'Anak-anak';
		ELSEIF age BETWEEN 18 AND 55 THEN
			SET category = 'Produktif';
		ELSE
			SET category = 'Lansia';
		END IF;

		RETURN category;
	END;//


	-- CREATE PROCEDURE send_email_notification(
	--     IN p_NIK_Pasien VARCHAR(10),
	--     IN p_Riwayat_ID INT,
	--     IN p_Subject VARCHAR(255),
	--     IN p_Message TEXT
	-- )
	-- BEGIN
	--     DECLARE v_Email VARCHAR(100);
	--     
	--     SELECT Email INTO v_Email
	--     FROM Pasien
	--     WHERE NIK_Pasien = p_NIK_Pasien;
	--     
	--     SELECT Riwayat_ID INTO p_Riwayat_ID
	--     FROM Riwayat
	--     WHERE NIK_Pasien = p_NIK_Pasien;
	--     
	--     INSERT INTO email_log (NIK_Pasien, Riwayat_ID, Email, Pesan)
	--     VALUES (p_NIK_Pasien, p_Riwayat_ID, v_Email, p_Message);

	-- END;//

	CREATE TRIGGER calculate_age_category_trigger
	BEFORE INSERT ON Pasien
	FOR EACH ROW
	BEGIN
		SET NEW.Usia = TIMESTAMPDIFF(YEAR, NEW.Tanggal_Lahir, CURDATE());
		SET NEW.Kategori = calculate_age_category(NEW.Tanggal_Lahir);
	END;//

	CREATE TRIGGER update_age_category_trigger
	BEFORE UPDATE ON Pasien
	FOR EACH ROW
	BEGIN
		SET NEW.Usia = TIMESTAMPDIFF(YEAR, NEW.Tanggal_Lahir, CURDATE());
		SET NEW.Kategori = calculate_age_category(NEW.Tanggal_Lahir);
	END;//

	-- CREATE TRIGGER email_notification_trigger
	-- AFTER INSERT ON Riwayat
	-- FOR EACH ROW
	-- BEGIN
	--     DECLARE v_Subject VARCHAR(255);
	--     DECLARE v_Message TEXT;
	--     
	--     -- Buat pesan untuk email
	--     SET v_Subject = 'Pemberitahuan Riwayat Baru';
	--     SET v_Message = CONCAT('Halo, Anda memiliki riwayat baru dengan ID ', NEW.Riwayat_ID, '. Silakan periksa informasi lebih lanjut.');
	--     
	--     CALL send_email_notification(NEW.NIK_Pasien, NEW.Riwayat_ID, v_Subject, v_Message);
	-- END;//

	DELIMITER ;


	-- Insert data ke dalam tabel pasien
	INSERT INTO pasien (NIK, password, email, usertype, nama_pasien, Tanggal_Lahir, alamat, tinggi, berat_badan, golongan_darah, alergi, no_telepon_pasien, jenis_kelamin) 
	VALUES 
	('1234567890', 'password123', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
    ('1234', 'password123', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
	('2345678901', 'password456', 'pasien2@example.com', 'pasien', 'Jane Smith', '1990-02-20', 'Alamat Pasien 2', 160, 55, 'A', 'Kacang', '082345678901', 'Perempuan'),
	('3456789012', 'password789', 'pasien3@example.com', 'pasien', 'Michael Johnson', '1987-03-25', 'Alamat Pasien 3', 180, 80, 'B', 'Serbuk sari', '083456789012', 'Laki-laki'),
	('4567890123', 'passwordabc', 'pasien4@example.com', 'pasien', 'Emily Brown', '1992-04-30', 'Alamat Pasien 4', 165, 60, 'AB', 'Laktosa', '084567890123', 'Perempuan'),
	('5678901234', 'passworddef', 'pasien5@example.com', 'pasien', 'Jessica Davis', '1988-05-15', 'Alamat Pasien 5', 170, 65, 'O', 'Debu', '085678901234', 'Perempuan');

	-- Insert data ke dalam tabel Rumah_Sakit
	INSERT INTO Rumah_Sakit (rumahsakit_id, nama_rumahsakit, alamat, no_telepon, kota) 
	VALUES 
	(1, 'RS A', 'Alamat RS A', '123456789', 'Kota A'),
	(2, 'RS B', 'Alamat RS B', '234567890', 'Kota B'),
	(3, 'RS C', 'Alamat RS C', '345678901', 'Kota C'),
	(4, 'RS D', 'Alamat RS D', '456789012', 'Kota D'),
	(5, 'RS E', 'Alamat RS E', '567890123', 'Kota E');

	-- Insert data ke dalam tabel tenaga_medis
	INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_Kelamin, no_telepon_tenagamedis) 
	VALUES 
	(101, 1, 'passmed123', 'medis1@example.com', 'tenaga medis', 'Dr. Johnson', 'Spesialis 1', 'Laki-laki', '081011223344'),
	(102, 2, 'passmed456', 'medis2@example.com', 'tenaga medis', 'Dr. Smith', 'Spesialis 2', 'Perempuan', '082122334455'),
	(103, 3, 'passmed789', 'medis3@example.com', 'tenaga medis', 'Dr. Brown', 'Spesialis 3', 'Laki-laki', '083233445566'),
	(104, 4, 'passmedabc', 'medis4@example.com', 'tenaga medis', 'Dr. Davis', 'Spesialis 4', 'Perempuan', '084344556677'),
	(105, 5, 'passmeddef', 'medis5@example.com', 'tenaga medis', 'Dr. Lee', 'Spesialis 5', 'Laki-laki', '085455667788');

	-- Insert data ke dalam tabel riwayat
	INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit) 
	VALUES 
    (12, '1234', 1, 101, '2024-05-01', 'Rawat Inap', 'Flu'),
    (13, '1234', 1, 101, '2024-05-01', 'Rawat Inap', 'Flu'),
	(14, '1234', 2, 102, '2024-05-02', 'Pemeriksaan', 'Demam'),
	(15, '1234', 2, 102, '2024-05-02', 'Pemeriksaan', 'Demam'),
	(1, '1234', 1, 101, '2024-05-01', 'Rawat Inap', 'Flu'),
	(2, '1234', 2, 102, '2024-05-02', 'Pemeriksaan', 'Demam'),
	(3, '3456789012', 3, 103, '2024-05-03', 'Operasi', 'Patah tulang'),
	(4, '4567890123', 4, 104, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
	(5, '5678901234', 5, 105, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
    (6, '1234567890', 1, 101, '2024-05-01', 'Operasi', 'Flu'),
    (7, '1234567890', 4, 104, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
	(8, '1234567890', 5, 105, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
    (9, '1234567890', 4, 104, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
	(10, '1234567890', 5, 105, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
    (11, '1234567890', 1, 101, '2024-05-01', 'Rawat Inap', 'Flu');

	-- Insert data ke dalam tabel obat
	INSERT INTO obat (obat_id, nama_obat, deskripsi) 
	VALUES 
	(1, 'Paracetamol', 'Obat penurun demam dan pereda nyeri'),
	(2, 'Amoxicillin', 'Antibiotik untuk infeksi bakteri'),
	(3, 'Ibuprofen', 'Obat antiinflamasi nonsteroid'),
	(4, 'Omeprazole', 'Obat untuk masalah pencernaan'),
	(5, 'Diazepam', 'Obat penenang dan antikecemasan');

	-- DELETE FROM pasien; 

	SELECT * FROM pasien;
	SELECT * FROM tenaga_medis;
	
