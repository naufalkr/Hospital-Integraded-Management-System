	create database if not exists db84;

	use db84;

		create table pasien
		(
			id     int,
			NIK char(18) primary key,
			password varchar(100) not null,
			email    varchar(50) not null,
			usertype varchar(20)  null,
			nama_pasien varchar(100) not null,
			Tanggal_Lahir DATE,
			alamat    varchar(100) not null,
			tinggi int,
			berat_badan int,
			golongan_darah varchar(5),
			alergi varchar(100),
			no_telepon_pasien varchar(15) not null,
			jenis_kelamin varchar(10) not null,
            profile_picture varchar(256)
		);
		
		CREATE TABLE Rumah_Sakit (
			id     int,
			rumahsakit_id INT PRIMARY KEY,
            password varchar(100) not null,
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

				-- Tabel obat
		CREATE TABLE obat (
			obat_id INT PRIMARY KEY,
			nama_obat VARCHAR(100),
			deskripsi VARCHAR(255)
		);


		CREATE TABLE riwayat (
			riwayat_id INT PRIMARY KEY,
			NIK char (17),
			rumahsakit_id INT,
			tenagamedis_id INT,
            obat_id INT,
			tanggal_riwayat DATE,
			jenis_layanan VARCHAR(60),
			keterangan_penyakit VARCHAR(60),
			FOREIGN KEY (NIK) REFERENCES pasien(NIK),
			FOREIGN KEY (rumahsakit_id) REFERENCES rumah_sakit(rumahsakit_id),
			FOREIGN KEY (tenagamedis_id) REFERENCES tenaga_medis(tenagamedis_id),
            FOREIGN KEY (obat_id) REFERENCES obat(obat_id)
		);


	-- Buat tabel email_log
CREATE TABLE email_log (
 		Log_ID INT AUTO_INCREMENT PRIMARY KEY,
		NIK CHAR(17),
 		Riwayat_ID INT,
 		Email VARCHAR(100),
 		Pesan TEXT,
 		Waktu_Kirim TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 		FOREIGN KEY (NIK) REFERENCES Pasien(NIK),
 		FOREIGN KEY (Riwayat_ID) REFERENCES Riwayat(Riwayat_ID)
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


-- Adjusted send_email_notification procedure
CREATE PROCEDURE send_email_notification(
    IN p_NIK CHAR(17),
    IN p_Riwayat_ID INT,
    IN p_Subject VARCHAR(255),
    IN p_Message TEXT
)
BEGIN
    DECLARE v_Email VARCHAR(100);
    
    -- Get the email of the patient using the provided NIK
    SELECT Email INTO v_Email
    FROM Pasien
    WHERE NIK = p_NIK;

    -- Insert the email log directly using the provided Riwayat_ID
    INSERT INTO email_log (NIK, Riwayat_ID, Email, Pesan)
    VALUES (p_NIK, p_Riwayat_ID, v_Email, p_Message);
END//

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

	-- Adjusted email_notification_trigger
CREATE TRIGGER email_notification_trigger
AFTER INSERT ON Riwayat
FOR EACH ROW
BEGIN
    DECLARE v_Subject VARCHAR(255);
    DECLARE v_Message TEXT;
    
    -- Create the subject and message for the email
    SET v_Subject = 'Pemberitahuan Riwayat Baru';
    SET v_Message = CONCAT('Halo, Anda memiliki riwayat baru dengan ID ', NEW.riwayat_id, '. Silakan periksa informasi lebih lanjut.');
    
    -- Call the procedure with the new values directly
    CALL send_email_notification(NEW.NIK, NEW.riwayat_id, v_Subject, v_Message);
END//

DELIMITER ;
-- 	
    

	-- Insert data ke dalam tabel pasien
-- 	INSERT INTO pasien (NIK, password, email, usertype, nama_pasien, Tanggal_Lahir, alamat, tinggi, berat_badan, golongan_darah, alergi, no_telepon_pasien, jenis_kelamin) 
-- 	VALUES 
-- 	('1432', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'pasien1@example.com', 'pasien', 'John Doe', '2020-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
--     ('1234', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
--     ('1345', 'password123', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
--     ('12346', 'password123', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
-- 	('1234567890', 'password456', 'pasien2@example.com', 'pasien', 'Jane Smith', '1990-02-20', 'Alamat Pasien 2', 160, 55, 'A', 'Kacang', '082345678901', 'Perempuan'),
-- 	('2345678901', 'password456', 'pasien2@example.com', 'pasien', 'Jane Smith', '1990-02-20', 'Alamat Pasien 2', 160, 55, 'A', 'Kacang', '082345678901', 'Perempuan'),
--     ('3456789012', 'password789', 'pasien3@example.com', 'pasien', 'Michael Johnson', '1987-03-25', 'Alamat Pasien 3', 180, 80, 'B', 'Serbuk sari', '083456789012', 'Laki-laki'),
-- 	('4567890123', 'passwordabc', 'pasien4@example.com', 'pasien', 'Emily Brown', '1992-04-30', 'Alamat Pasien 4', 165, 60, 'AB', 'Laktosa', '084567890123', 'Perempuan'),
-- 	('5678901234', 'passworddef', 'pasien5@example.com', 'pasien', 'Jessica Davis', '1988-05-15', 'Alamat Pasien 5', 170, 65, 'O', 'Debu', '085678901234', 'Perempuan');

	-- Insert data ke dalam tabel Rumah_Sakit
-- 	INSERT INTO Rumah_Sakit (rumahsakit_id, nama_rumahsakit, alamat, no_telepon, kota) 
-- 	VALUES 
-- 	(1, 'RS A', 'Alamat RS A', '123456789', 'Kota A'),
-- 	(2, 'RS B', 'Alamat RS B', '234567890', 'Kota B'),
-- 	(3, 'RS C', 'Alamat RS C', '345678901', 'Kota C'),
-- 	(4, 'RS D', 'Alamat RS D', '456789012', 'Kota D'),
-- 	(5, 'RS E', 'Alamat RS E', '567890123', 'Kota E');
	
--     INSERT INTO Rumah_Sakit (rumahsakit_id, nama_rumahsakit, alamat, no_telepon, kota) 
-- 	VALUES 
-- 	(502522, 'Rumah Sakit Harapan Kita', 'Jl. Karawaci', '081122334455', 'Tangerang');
--     
-- 	INSERT INTO Rumah_Sakit (rumahsakit_id, nama_rumahsakit, alamat, no_telepon, kota) 
-- 	VALUES 
-- 	(502523, 'Rumah Sakit Bintaro Premier', 'Jl. Bintaro', '081122334455', 'Tangerang');
--     
-- 	-- Insert data ke dalam tabel tenaga_medis
-- 	INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_Kelamin, no_telepon_tenagamedis) 
-- 	VALUES 
-- 	(101, 1, 'passmed123', 'medis1@example.com', 'tenaga medis', 'Dr. Johnson', 'Spesialis 1', 'Laki-laki', '081011223344'),
-- 	(102, 2, 'passmed456', 'medis2@example.com', 'tenaga medis', 'Dr. Smith', 'Spesialis 2', 'Perempuan', '082122334455'),
-- 	(103, 3, 'passmed789', 'medis3@example.com', 'tenaga medis', 'Dr. Brown', 'Spesialis 3', 'Laki-laki', '083233445566'),
-- 	(104, 4, 'passmedabc', 'medis4@example.com', 'tenaga medis', 'Dr. Davis', 'Spesialis 4', 'Perempuan', '084344556677'),
-- 	(105, 5, 'passmeddef', 'medis5@example.com', 'tenaga medis', 'Dr. Lee', 'Spesialis 5', 'Laki-laki', '085455667788');
-- 	
    
-- INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_kelamin, no_telepon_tenagamedis) 
-- VALUES 
--     (111, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis111@example.com', 'tenaga medis', 'Dr. John Doe', 'Ortopedi', 'Laki-laki', '081011223344'),
--     (112, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis112@example.com', 'tenaga medis', 'Dr. Jane Smith', 'Kardiologi', 'Perempuan', '082011223344'),
--     (113, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis113@example.com', 'tenaga medis', 'Dr. Michael Brown', 'Neurologi', 'Laki-laki', '083011223344'),
--     (114, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis114@example.com', 'tenaga medis', 'Dr. Emily Davis', 'Pediatri', 'Perempuan', '084011223344'),
--     (115, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis115@example.com', 'tenaga medis', 'Dr. William Johnson', 'Dermatologi', 'Laki-laki', '085011223344'),
--     (116, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis116@example.com', 'tenaga medis', 'Dr. Olivia Wilson', 'Oftalmologi', 'Perempuan', '086011223344'),
--     (117, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis117@example.com', 'tenaga medis', 'Dr. James Moore', 'Ginekologi', 'Laki-laki', '087011223344'),
--     (118, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis118@example.com', 'tenaga medis', 'Dr. Sophia Taylor', 'Onkologi', 'Perempuan', '088011223344'),
--     (119, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis119@example.com', 'tenaga medis', 'Dr. Benjamin Anderson', 'Psikiatri', 'Laki-laki', '089011223344'),
--     (120, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis120@example.com', 'tenaga medis', 'Dr. Amelia Martinez', 'Urologi', 'Perempuan', '080011223344'),
--     (121, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis121@example.com', 'tenaga medis', 'Dr. Elijah Thomas', 'Gastroenterologi', 'Laki-laki', '081122334455'),
--     (122, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis122@example.com', 'tenaga medis', 'Dr. Mia Jackson', 'Endokrinologi', 'Perempuan', '082122334455'),
--     (123, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis123@example.com', 'tenaga medis', 'Dr. Daniel White', 'Hematologi', 'Laki-laki', '083122334455'),
--     (124, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis124@example.com', 'tenaga medis', 'Dr. Charlotte Harris', 'Nefrologi', 'Perempuan', '084122334455'),
--     (125, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis125@example.com', 'tenaga medis', 'Dr. Lucas Martin', 'Pulmonologi', 'Laki-laki', '085122334455');

-- INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_kelamin, no_telepon_tenagamedis) 
-- VALUES 
--     (131, 502523, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis111@example.com', 'tenaga medis', 'Dr. A', 'Ortopedi', 'Laki-laki', '081011223344'),
--     (132, 502523, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis112@example.com', 'tenaga medis', 'Dr. B', 'Kardiologi', 'Perempuan', '082011223344'),
--     (133, 502523, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis113@example.com', 'tenaga medis', 'Dr. C', 'Neurologi', 'Laki-laki', '083011223344');

-- INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_Kelamin, no_telepon_tenagamedis) 
-- 	VALUES 
-- 	(1004, 1, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis1@example.com', 'tenaga medis', 'Dr. Naufal', 'Spesialis 1', 'Laki-laki', '081011223344');

	-- Insert data ke dalam tabel obat
-- INSERT INTO obat (obat_id, nama_obat, deskripsi) VALUES
-- (1, 'Paracetamol', 'Obat penurun demam dan pereda nyeri'),
-- (2, 'Ibuprofen', 'Obat anti-inflamasi nonsteroid'),
-- (3, 'Amoxicillin', 'Antibiotik untuk infeksi bakteri'),
-- (4, 'Ranitidine', 'Obat untuk gangguan pencernaan'),
-- (5, 'Cetirizine', 'Antihistamin untuk alergi'),
-- (6, 'Salbutamol', 'Obat untuk asma'),
-- (7, 'Metformin', 'Obat untuk diabetes'),
-- (8, 'Atorvastatin', 'Obat untuk kolesterol tinggi'),
-- (9, 'Omeprazole', 'Obat untuk tukak lambung'),
-- (10, 'Amlodipine', 'Obat untuk tekanan darah tinggi'),
-- (11, 'Ciprofloxacin', 'Antibiotik untuk infeksi bakteri'),
-- (12, 'Levothyroxine', 'Obat untuk hipotiroidisme');

-- INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
-- VALUES-- 
-- (4, '4567890123', 4, 104, 2, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (5, '5678901234', 5, 105, 2, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (6, '1234567890', 1, 101, 2, '2024-05-01', 'Operasi', 'Flu'),
-- (7, '1234', 4, 104, 2, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (8, '1234567890', 5, 105, 2, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (9, '1234567890', 4, 104, 2, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (10, '1234567890', 5, 105, 2, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (11, '1234567890', 1, 101, 2, '2024-05-01', 'Rawat Inap', 'Flu');

-- INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
-- VALUES
-- (3001, '1432', 3, 103, 3, '2024-05-03', 'Operasi', 'Patah tulang'),
-- (3002, '1432', 4, 104, 3, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (3003, '1432', 5, 105, 3, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (3004, '1432', 1, 101, 3, '2024-05-01', 'Operasi', 'Flu'),
-- (3005, '1432', 4, 104, 3, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (3006, '1432', 5, 105, 3, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (3010, '1432', 4, 104, 3, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (3008, '1432', 5, 105, 3, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (3009, '1432', 1, 101, 3, '2024-05-01', 'Rawat Inap', 'Flu');

-- INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
-- VALUES
-- (1010, '1234567890', 502522, 103, 4, '2024-05-03', 'Operasi', 'Patah tulang'),
-- (2008, '1234567890', 502522, 104, 4, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (3007, '1234567890', 502522, 105, 4, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (4006, '1234567890', 502522, 101, 4, '2024-05-01', 'Operasi', 'Flu'),
-- (5005, '1234567890', 502522, 104, 4, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (1004, '3456789012', 502522, 105, 4, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (1003, '3456789012', 502522, 104, 4, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
-- (1002, '3456789012', 502522, 105, 4, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
-- (1001, '3456789012', 502522, 101, 4, '2024-05-01', 'Rawat Inap', 'Flu');

-- INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
-- VALUES
-- (101, '3456789012', 3, 115, 5, '2024-05-03', 'Operasi', 'Patah tulang');

-- INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
-- VALUES
-- (102, '3456789012', 3, 115, 6, '2024-05-03', 'Operasi', 'Patah tulang'),
-- (103, '1234567890', 3, 115, 6, '2024-05-04', 'Konsultasi', 'Demam'),
-- (104, '1234567890', 3, 115, 6, '2024-05-05', 'Pemeriksaan', 'Flu'),
-- (105, '3456789012', 3, 115, 6, '2024-05-06', 'Operasi Darurat', 'Kecelakaan'),
-- (106, '1234', 3, 115, 6, '2024-05-07', 'Operasi', 'Patah tangan'),
-- (107, '3456789012', 3, 115, 6, '2024-05-08', 'Rawat Inap', 'Infeksi'),
-- (108, '1234', 3, 115, 6, '2024-05-09', 'Konsultasi', 'Sakit perut');



-- INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
-- VALUES
-- (42, '1345', 1, 101, 7, '2024-05-01', 'Rawat Inap', 'Flu'),
-- (43, '1345', 1, 101, 7, '2024-05-12', 'Rawat Inap', 'Flu'),
-- (44, '1345', 2, 102, 7, '2024-05-15', 'Pemeriksaan', 'Demam');
-- 	-- DELETE FROM pasien; 

	INSERT INTO pasien (NIK, password, email, usertype, nama_pasien, Tanggal_Lahir, alamat, tinggi, berat_badan, golongan_darah, alergi, no_telepon_pasien, jenis_kelamin) VALUES
	('1234567890123456', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example1@example.com', 'pasien', 'Alesandro Del Piero', '1990-01-01', 'Jl. Merdeka No. 1, Jakarta', 170, 65, 'A', 'Debu', '081234567890', 'Laki-laki'),
	('1234567890123457', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example2@example.com', 'pasien', 'Budi Hartono', '1985-02-02', 'Jl. Kemerdekaan No. 2, Bandung', 168, 70, 'B', 'Polen', '081234567891', 'Laki-laki'),
	('1234567890123458', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example3@example.com', 'pasien', 'Siti Nurhaliza', '1992-03-03', 'Jl. Pahlawan No. 3, Surabaya', 160, 55, 'O', 'Kacang', '081234567892', 'Perempuan'),
	('1234567890123459', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example4@example.com', 'pasien', 'John Doe', '1988-04-04', 'Jl. Sukarno No. 4, Medan', 175, 68, 'AB', 'Udang', '081234567893', 'Laki-laki'),
	('1234567890123460', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example5@example.com', 'pasien', 'Jane Smith', '1995-05-05', 'Jl. Hatta No. 5, Yogyakarta', 165, 60, 'A', 'Debu', '081234567894', 'Perempuan'),
	('1234567890123461', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example6@example.com', 'pasien', 'Michael Johnson', '1991-06-06', 'Jl. Sisingamangaraja No. 6, Makassar', 180, 75, 'B', 'Polen', '081234567895', 'Laki-laki'),
	('1234567890123462', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example7@example.com', 'pasien', 'Emily Davis', '1987-07-07', 'Jl. Diponegoro No. 7, Semarang', 158, 52, 'O', 'Kacang', '081234567896', 'Perempuan'),
	('1234567890123463', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example8@example.com', 'pasien', 'David Wilson', '1993-08-08', 'Jl. Imam Bonjol No. 8, Palembang', 172, 68, 'AB', 'Udang', '081234567897', 'Laki-laki'),
	('1234567890123464', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example9@example.com', 'pasien', 'Linda Martinez', '1989-09-09', 'Jl. Gatot Subroto No. 9, Denpasar', 164, 58, 'A', 'Debu', '081234567898', 'Perempuan'),
	('1234567890123465', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example10@example.com', 'pasien', 'James Brown', '1996-10-10', 'Jl. Thamrin No. 10, Malang', 178, 72, 'B', 'Polen', '081234567899', 'Laki-laki'),
	-- tambahkan 90 baris data lainnya sesuai pola di atas
	('1234567890123466', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example11@example.com', 'pasien', 'Robert Clark', '1983-11-11', 'Jl. Sudirman No. 11, Bekasi', 182, 77, 'O', 'Kacang', '081234567900', 'Laki-laki'),
	('1234567890123467', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example12@example.com', 'pasien', 'Barbara Lewis', '1984-12-12', 'Jl. Daan Mogot No. 12, Depok', 160, 53, 'AB', 'Udang', '081234567901', 'Perempuan'),
	('1234567890123468', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example13@example.com', 'pasien', 'Paul Walker', '1980-01-13', 'Jl. Kuningan No. 13, Jakarta', 175, 69, 'A', 'Debu', '081234567902', 'Laki-laki'),
	('1234567890123469', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example14@example.com', 'pasien', 'Patricia Hall', '1982-02-14', 'Jl. Merdeka No. 14, Bogor', 167, 62, 'B', 'Polen', '081234567903', 'Perempuan'),
	('1234567890123470', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example15@example.com', 'pasien', 'George Harris', '1979-03-15', 'Jl. Diponegoro No. 15, Tangerang', 169, 66, 'O', 'Kacang', '081234567904', 'Laki-laki'),
	('1234567890123471', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example16@example.com', 'pasien', 'Nancy Robinson', '1985-04-16', 'Jl. Imam Bonjol No. 16, Serang', 162, 55, 'AB', 'Udang', '081234567905', 'Perempuan'),
	('1234567890123472', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example17@example.com', 'pasien', 'Kenneth Young', '1987-05-17', 'Jl. Gatot Subroto No. 17, Bandung', 176, 70, 'A', 'Debu', '081234567906', 'Laki-laki'),
	('1234567890123473', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example18@example.com', 'pasien', 'Karen Allen', '1981-06-18', 'Jl. Sudirman No. 18, Jakarta', 165, 57, 'B', 'Polen', '081234567907', 'Perempuan'),
	('1234567890123474', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example19@example.com', 'pasien', 'Steven King', '1990-07-19', 'Jl. Thamrin No. 19, Surabaya', 180, 72, 'O', 'Kacang', '081234567908', 'Laki-laki'),
	('1234567890123475', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example20@example.com', 'pasien', 'Betty Wright', '1992-08-20', 'Jl. Merdeka No. 20, Yogyakarta', 158, 50, 'AB', 'Udang', '081234567909', 'Perempuan'),
	('1234567890123476', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example21@example.com', 'pasien', 'Charles Scott', '1988-09-21', 'Jl. Diponegoro No. 21, Malang', 174, 68, 'A', 'Debu', '081234567910', 'Laki-laki'),
	('1234567890123477', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example22@example.com', 'pasien', 'Sandra Green', '1994-10-22', 'Jl. Imam Bonjol No. 22, Medan', 164, 56, 'B', 'Polen', '081234567911', 'Perempuan'),
	('1234567890123478', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example23@example.com', 'pasien', 'Thomas Adams', '1986-11-23', 'Jl. Gatot Subroto No. 23, Makassar', 172, 67, 'O', 'Kacang', '081234567912', 'Laki-laki'),
	('1234567890123479', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example24@example.com', 'pasien', 'Jessica Baker', '1983-12-24', 'Jl. Sudirman No. 24, Denpasar', 168, 60, 'AB', 'Udang', '081234567913', 'Perempuan'),
	('1234567890123480', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example25@example.com', 'pasien', 'Matthew Carter', '1989-01-25', 'Jl. Thamrin No. 25, Bogor', 178, 73, 'A', 'Debu', '081234567914', 'Laki-laki'),
	('1234567890123481', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example26@example.com', 'pasien', 'Margaret Turner', '1991-02-26', 'Jl. Merdeka No. 26, Tangerang', 162, 55, 'B', 'Polen', '081234567915', 'Perempuan'),
	('1234567890123482', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example27@example.com', 'pasien', 'Christopher Edwards', '1995-03-27', 'Jl. Diponegoro No. 27, Semarang', 175, 70, 'O', 'Kacang', '081234567916', 'Laki-laki'),
	('1234567890123483', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example28@example.com', 'pasien', 'Dorothy Collins', '1993-04-28', 'Jl. Imam Bonjol No. 28, Bekasi', 160, 53, 'AB', 'Udang', '081234567917', 'Perempuan'),
	('1234567890123484', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example29@example.com', 'pasien', 'Daniel Stewart', '1984-05-29', 'Jl. Gatot Subroto No. 29, Depok', 177, 71, 'A', 'Debu', '081234567918', 'Laki-laki'),
	('1234567890123485', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example30@example.com', 'pasien', 'Sarah Morris', '1982-06-30', 'Jl. Sudirman No. 30, Palembang', 166, 59, 'B', 'Polen', '081234567919', 'Perempuan'),
	('1234567890123486', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example31@example.com', 'pasien', 'Joseph Rogers', '1986-07-31', 'Jl. Thamrin No. 31, Denpasar', 181, 75, 'O', 'Kacang', '081234567920', 'Laki-laki'),
	('1234567890123487', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example32@example.com', 'pasien', 'Karen Cook', '1988-08-01', 'Jl. Merdeka No. 32, Jakarta', 164, 56, 'AB', 'Udang', '081234567921', 'Perempuan'),
	('1234567890123488', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example33@example.com', 'pasien', 'Mark Campbell', '1992-09-02', 'Jl. Diponegoro No. 33, Bandung', 179, 72, 'A', 'Debu', '081234567922', 'Laki-laki'),
	('1234567890123489', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example34@example.com', 'pasien', 'Betty Rodriguez', '1983-10-03', 'Jl. Imam Bonjol No. 34, Surabaya', 160, 54, 'B', 'Polen', '081234567923', 'Perempuan'),
	('1234567890123490', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example35@example.com', 'pasien', 'Donald Bailey', '1987-11-04', 'Jl. Gatot Subroto No. 35, Yogyakarta', 173, 69, 'O', 'Kacang', '081234567924', 'Laki-laki'),
	('1234567890123491', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example36@example.com', 'pasien', 'Nancy Rivera', '1981-12-05', 'Jl. Sudirman No. 36, Malang', 165, 58, 'AB', 'Udang', '081234567925', 'Perempuan'),
	('1234567890123492', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example37@example.com', 'pasien', 'Ronald Ramirez', '1990-01-06', 'Jl. Thamrin No. 37, Medan', 178, 71, 'A', 'Debu', '081234567926', 'Laki-laki'),
	('1234567890123493', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example38@example.com', 'pasien', 'Helen Bell', '1985-02-07', 'Jl. Merdeka No. 38, Makassar', 162, 55, 'B', 'Polen', '081234567927', 'Perempuan'),
	('1234567890123494', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example39@example.com', 'pasien', 'Gary Price', '1989-03-08', 'Jl. Diponegoro No. 39, Denpasar', 175, 70, 'O', 'Kacang', '081234567928', 'Laki-laki'),
	('1234567890123495', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example40@example.com', 'pasien', 'Deborah Lopez', '1994-04-09', 'Jl. Imam Bonjol No. 40, Bogor', 166, 59, 'AB', 'Udang', '081234567929', 'Perempuan'),
	('1234567890123496', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example41@example.com', 'pasien', 'George Hill', '1988-05-10', 'Jl. Gatot Subroto No. 41, Tangerang', 172, 67, 'A', 'Debu', '081234567930', 'Laki-laki'),
	('1234567890123497', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example42@example.com', 'pasien', 'Pamela Sanchez', '1992-06-11', 'Jl. Sudirman No. 42, Serang', 159, 54, 'B', 'Polen', '081234567931', 'Perempuan'),
	('1234567890123498', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example43@example.com', 'pasien', 'Edward Young', '1993-07-12', 'Jl. Thamrin No. 43, Bandung', 174, 69, 'O', 'Kacang', '081234567932', 'Laki-laki'),
	('1234567890123499', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example44@example.com', 'pasien', 'Kimberly Mitchell', '1987-08-13', 'Jl. Merdeka No. 44, Jakarta', 161, 55, 'AB', 'Udang', '081234567933', 'Perempuan'),
	('1234567890123500', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example45@example.com', 'pasien', 'Brian Perez', '1981-09-14', 'Jl. Diponegoro No. 45, Surabaya', 177, 71, 'A', 'Debu', '081234567934', 'Laki-laki'),
	('1234567890123501', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example46@example.com', 'pasien', 'Lisa Roberts', '1985-10-15', 'Jl. Imam Bonjol No. 46, Yogyakarta', 165, 58, 'B', 'Polen', '081234567935', 'Perempuan'),
	('1234567890123502', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example47@example.com', 'pasien', 'Eric Martinez', '1990-11-16', 'Jl. Gatot Subroto No. 47, Malang', 179, 72, 'O', 'Kacang', '081234567936', 'Laki-laki'),
	('1234567890123503', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example48@example.com', 'pasien', 'Dorothy Clark', '1984-12-17', 'Jl. Sudirman No. 48, Medan', 162, 55, 'AB', 'Udang', '081234567937', 'Perempuan'),
	('1234567890123504', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example49@example.com', 'pasien', 'Daniel Lewis', '1993-01-18', 'Jl. Thamrin No. 49, Makassar', 175, 70, 'A', 'Debu', '081234567938', 'Laki-laki'),
	('1234567890123505', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example50@example.com', 'pasien', 'Sandra Walker', '1995-02-19', 'Jl. Merdeka No. 50, Denpasar', 160, 53, 'B', 'Polen', '081234567939', 'Perempuan'),
	('1234567890123506', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example51@example.com', 'pasien', 'Matthew Harris', '1982-03-20', 'Jl. Diponegoro No. 51, Bogor', 180, 74, 'O', 'Kacang', '081234567940', 'Laki-laki'),
	('1234567890123507', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example52@example.com', 'pasien', 'Karen Hall', '1992-04-21', 'Jl. Imam Bonjol No. 52, Tangerang', 158, 50, 'AB', 'Udang', '081234567941', 'Perempuan'),
	('1234567890123508', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example53@example.com', 'pasien', 'John Allen', '1980-05-22', 'Jl. Gatot Subroto No. 53, Serang', 170, 66, 'A', 'Debu', '081234567942', 'Laki-laki'),
	('1234567890123509', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example54@example.com', 'pasien', 'Linda Young', '1987-06-23', 'Jl. Sudirman No. 54, Bandung', 165, 59, 'B', 'Polen', '081234567943', 'Perempuan'),
	('1234567890123510', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example55@example.com', 'pasien', 'David Hernandez', '1990-07-24', 'Jl. Thamrin No. 55, Jakarta', 174, 70, 'O', 'Kacang', '081234567944', 'Laki-laki'),
	('1234567890123511', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example56@example.com', 'pasien', 'Barbara King', '1992-08-25', 'Jl. Merdeka No. 56, Surabaya', 160, 54, 'AB', 'Udang', '081234567945', 'Perempuan'),
	('1234567890123512', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example57@example.com', 'pasien', 'James Wright', '1988-09-26', 'Jl. Diponegoro No. 57, Yogyakarta', 177, 71, 'A', 'Debu', '081234567946', 'Laki-laki'),
	('1234567890123513', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example58@example.com', 'pasien', 'Mary Scott', '1994-10-27', 'Jl. Imam Bonjol No. 58, Malang', 165, 58, 'B', 'Polen', '081234567947', 'Perempuan'),
	('1234567890123514', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example59@example.com', 'pasien', 'John Green', '1986-11-28', 'Jl. Gatot Subroto No. 59, Medan', 179, 72, 'O', 'Kacang', '081234567948', 'Laki-laki'),
	('1234567890123515', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'example60@example.com', 'pasien', 'Patricia Adams', '1989-12-29', 'Jl. Sudirman No. 60, Makassar', 164, 56, 'AB', 'Udang', '081234567949', 'Perempuan');


	UPDATE pasien
	SET profile_picture = CASE
		WHEN jenis_kelamin = 'Laki-laki' THEN
			CASE FLOOR(RAND() * 3)
				WHEN 0 THEN 'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg'
				WHEN 1 THEN 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEH14u7rKYD9aCAr-qRwTjpnXljCPuy4xbQSkW4HWJtCFReJNpt0-3ZW3MQyiyaIWoYyI&usqp=CAU'
				ELSE 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTlpGrChUF2bXo933z1jOm5qvhTNrWPV5_s0huKYD0ReiECe15MmpbGUnTmjCAZuNIK3w&usqp=CAU'
			END
		WHEN jenis_kelamin = 'Perempuan' THEN
			CASE FLOOR(RAND() * 2)
				WHEN 0 THEN 'https://wp.catholicmatch.com/wp-content/uploads/2021/02/pexels-giftpunditscom-1310535-scaled-e1614001127258-1024x682.jpg'
				ELSE 'https://i0.wp.com/www.alphr.com/wp-content/uploads/2020/12/Facebook-How-to-Change-Profile-Picture.jpg?resize=230%2C170&ssl=1'
			END
		ELSE profile_picture  -- handle default case if needed
	END;


	INSERT INTO obat (obat_id, nama_obat, Deskripsi) VALUES
	(1, 'Paracetamol', 'Analgesik dan antipiretik untuk meredakan demam dan nyeri ringan hingga sedang.'),
	(2, 'Ibuprofen', 'Anti-inflamasi nonsteroid (NSAID) untuk mengurangi peradangan, nyeri, dan demam.'),
	(3, 'Amoxicillin', 'Antibiotik untuk mengobati berbagai infeksi bakteri.'),
	(4, 'Cetirizine', 'Antihistamin untuk mengobati gejala alergi seperti gatal dan bersin.'),
	(5, 'Metformin', 'Obat diabetes untuk mengontrol kadar gula darah pada penderita diabetes tipe 2.'),
	(6, 'Lisinopril', 'Inhibitor ACE untuk mengobati tekanan darah tinggi dan gagal jantung.'),
	(7, 'Aspirin', 'Antiplatelet untuk mencegah serangan jantung dan stroke, juga digunakan sebagai analgesik.'),
	(8, 'Atorvastatin', 'Statin untuk menurunkan kadar kolesterol dan mengurangi risiko penyakit jantung.'),
	(9, 'Omeprazole', 'Inhibitor pompa proton untuk mengobati GERD dan tukak lambung.'),
	(10, 'Losartan', 'Antagonis reseptor angiotensin II untuk mengobati tekanan darah tinggi.'),
	(11, 'Salbutamol', 'Bronkodilator untuk meredakan gejala asma dan penyakit paru obstruktif kronik (PPOK).'),
	(12, 'Levothyroxine', 'Obat pengganti hormon tiroid untuk mengobati hipotiroidisme.'),
	(13, 'Amlodipine', 'Calcium channel blocker untuk mengobati tekanan darah tinggi dan angina.'),
	(14, 'Simvastatin', 'Statin untuk mengurangi kadar kolesterol dalam darah.'),
	(15, 'Ciprofloxacin', 'Antibiotik untuk mengobati berbagai infeksi bakteri.'),
	(16, 'Hydrochlorothiazide', 'Diuretik untuk mengobati tekanan darah tinggi dan edema.'),
	(17, 'Metoprolol', 'Beta blocker untuk mengobati tekanan darah tinggi, angina, dan serangan jantung.'),
	(18, 'Furosemide', 'Diuretik loop untuk mengobati edema yang terkait dengan gagal jantung dan gangguan ginjal.'),
	(19, 'Captopril', 'Inhibitor ACE untuk mengobati tekanan darah tinggi dan gagal jantung.'),
	(20, 'Clopidogrel', 'Antiplatelet untuk mencegah serangan jantung dan stroke.'),
	(21, 'Pantoprazole', 'Inhibitor pompa proton untuk mengobati GERD dan tukak lambung.'),
	(22, 'Dextromethorphan', 'Antitusif untuk meredakan batuk kering.'),
	(23, 'Diazepam', 'Benzodiazepin untuk mengobati kecemasan, kejang, dan gejala putus alkohol.'),
	(24, 'Fluoxetine', 'Antidepresan untuk mengobati depresi, OCD, dan gangguan panik.'),
	(25, 'Gabapentin', 'Obat antikonvulsan untuk mengobati nyeri saraf dan epilepsi.'),
	(26, 'Naproxen', 'NSAID untuk mengurangi peradangan, nyeri, dan demam.'),
	(27, 'Prednisone', 'Kortikosteroid untuk mengobati berbagai kondisi inflamasi dan autoimun.'),
	(28, 'Sertraline', 'Antidepresan untuk mengobati depresi, OCD, dan PTSD.'),
	(29, 'Tamsulosin', 'Alpha blocker untuk mengobati pembesaran prostat (BPH).'),
	(30, 'Tramadol', 'Analgesik untuk meredakan nyeri sedang hingga berat.'),
	(31, 'Warfarin', 'Antikoagulan untuk mencegah pembekuan darah.'),
	(32, 'Azithromycin', 'Antibiotik untuk mengobati berbagai infeksi bakteri.'),
	(33, 'Budesonide', 'Kortikosteroid untuk mengobati asma dan penyakit Crohn.'),
	(34, 'Cetirizine', 'Antihistamin untuk mengobati gejala alergi seperti gatal dan bersin.'),
	(35, 'Clindamycin', 'Antibiotik untuk mengobati infeksi bakteri serius.'),
	(36, 'Doxycycline', 'Antibiotik untuk mengobati berbagai infeksi bakteri.'),
	(37, 'Esomeprazole', 'Inhibitor pompa proton untuk mengobati GERD dan tukak lambung.'),
	(38, 'Insulin Glargine', 'Insulin kerja panjang untuk mengontrol kadar gula darah pada diabetes.'),
	(39, 'Loratadine', 'Antihistamin untuk mengobati gejala alergi seperti gatal dan bersin.'),
	(40, 'Meloxicam', 'NSAID untuk mengurangi peradangan, nyeri, dan demam.'),
	(41, 'Nitroglycerin', 'Vasodilator untuk mengobati angina.'),
	(42, 'Ondansetron', 'Antiemetik untuk mencegah mual dan muntah akibat kemoterapi atau operasi.'),
	(43, 'Ranitidine', 'Antagonis H2 untuk mengobati tukak lambung dan GERD.'),
	(44, 'Rosuvastatin', 'Statin untuk menurunkan kadar kolesterol dan mengurangi risiko penyakit jantung.'),
	(45, 'Salmeterol', 'Bronkodilator untuk mengobati asma dan PPOK.'),
	(46, 'Spironolactone', 'Diuretik hemat kalium untuk mengobati edema dan hipertensi.'),
	(47, 'Sulfamethoxazole/Trimethoprim', 'Antibiotik kombinasi untuk mengobati berbagai infeksi bakteri.'),
	(48, 'Valproic Acid', 'Antikonvulsan untuk mengobati epilepsi dan gangguan bipolar.'),
	(49, 'Venlafaxine', 'Antidepresan untuk mengobati depresi, gangguan kecemasan, dan panik.'),
	(50, 'Zolpidem', 'Obat tidur untuk mengobati insomnia.');

	INSERT INTO Rumah_Sakit (rumahsakit_id, password, nama_rumahsakit, alamat, no_telepon, kota) VALUES
	(5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'Rumah Sakit Bintaro Jaya', 'Jl. Thamrin No.1', '0211234567', 'Tangerang'),
	(5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Harapan Kita', 'Jl. Pemuda No.2', '0311234567', 'Surabaya'),
	(5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Mayapada Jakarta', 'Jl. Asia Afrika No.3', '0221234567', 'Jakarta'),
	(5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Muhammadiyah', 'Jl. Malioboro No.4', '02741234567', 'Yogyakarta'),
	(5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Pusat Pertamina', 'Jl. Gatot Subroto No.5', '0611234567', 'Medan'),
	(5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Denpasar Medical Care', 'Jl. Sudirman No.6', '03611234567', 'Denpasar'),
	(5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Siloam TB Simatupang', 'Jl. Ahmad Yani No.7', '04111234567', 'Makassar'),
	(5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Siloam Semanggi', 'Jl. Pandanaran No.8', '0241234567', 'Semarang'),
	(5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC',  'Rumah Sakit Premier Palembang', 'Jl. Sudirman No.9', '07111234567', 'Palembang'),
	(5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'Rumah Sakit Siloam Kebon Jeruk', 'Jl. Raya Kebon Jeruk No.1', '0212345678', 'Jakarta');

	INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_Kelamin, no_telepon_tenagamedis) VALUES
	(1001, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsjakarta.com', 'Doctor', 'Dr. Agus Santoso', 'Cardiologist', 'Male', '0812100011'),
	(1002, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsjakarta.com', 'Doctor', 'Dr. Budi Prasetyo', 'Neurologist', 'Male', '0812100012'),
	(1003, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsjakarta.com', 'Doctor', 'Dr. Siti Aminah', 'Pediatrician', 'Female', '0812100013'),
	(1004, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsjakarta.com', 'Doctor', 'Dr. Rina Puspita', 'Oncologist', 'Female', '0812100014'),
	(1005, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsjakarta.com', 'Doctor', 'Dr. Eko Susanto', 'Dermatologist', 'Male', '0812100015'),
	(1006, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsjakarta.com', 'Doctor', 'Dr. Nina Kurnia', 'Endocrinologist', 'Female', '0812100016'),
	(1007, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsjakarta.com', 'Doctor', 'Dr. Wahyu Setiawan', 'Gastroenterologist', 'Male', '0812100017'),
	(1008, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsjakarta.com', 'Doctor', 'Dr. Dewi Lestari', 'Rheumatologist', 'Female', '0812100018'),
	(1009, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsjakarta.com', 'Doctor', 'Dr. Ahmad Fauzi', 'Urologist', 'Male', '0812100019'),
	(1010, 5021, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsjakarta.com', 'Doctor', 'Dr. Rika Amelia', 'Hematologist', 'Female', '0812100020'),
	(1011, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rssurabaya.com', 'Doctor', 'Dr. Budi Hartono', 'Ophthalmologist', 'Male', '0812110011'),
	(1012, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rssurabaya.com', 'Doctor', 'Dr. Dian Widya', 'Allergist', 'Female', '0812110012'),
	(1013, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rssurabaya.com', 'Doctor', 'Dr. Yudi Saputra', 'Pulmonologist', 'Male', '0812110013'),
	(1014, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rssurabaya.com', 'Doctor', 'Dr. Maya Hapsari', 'Nephrologist', 'Female', '0812110014'),
	(1015, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rssurabaya.com', 'Doctor', 'Dr. Wawan Kurniawan', 'Orthopedic Surgeon', 'Male', '0812110015'),
	(1016, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rssurabaya.com', 'Doctor', 'Dr. Lestari Utami', 'Obstetrician', 'Female', '0812110016'),
	(1017, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rssurabaya.com', 'Doctor', 'Dr. Andi Gunawan', 'Otolaryngologist', 'Male', '0812110017'),
	(1018, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rssurabaya.com', 'Doctor', 'Dr. Sari Wulandari', 'Plastic Surgeon', 'Female', '0812110018'),
	(1019, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rssurabaya.com', 'Doctor', 'Dr. Bambang Setiaji', 'Radiologist', 'Male', '0812110019'),
	(1020, 5022, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rssurabaya.com', 'Doctor', 'Dr. Ratna Dewi', 'Anesthesiologist', 'Female', '0812110020'),
	(1021, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsbandung.com', 'Doctor', 'Dr. Agus Riyadi', 'Cardiologist', 'Male', '0812120011'),
	(1022, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsbandung.com', 'Doctor', 'Dr. Dian Lestari', 'Neurologist', 'Female', '0812120012'),
	(1023, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsbandung.com', 'Doctor', 'Dr. Wawan Haryanto', 'Pediatrician', 'Male', '0812120013'),
	(1024, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsbandung.com', 'Doctor', 'Dr. Siti Nuraini', 'Oncologist', 'Female', '0812120014'),
	(1025, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsbandung.com', 'Doctor', 'Dr. Eko Priyanto', 'Dermatologist', 'Male', '0812120015'),
	(1026, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsbandung.com', 'Doctor', 'Dr. Nina Kusuma', 'Endocrinologist', 'Female', '0812120016'),
	(1027, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsbandung.com', 'Doctor', 'Dr. Wahyu Handoko', 'Gastroenterologist', 'Male', '0812120017'),
	(1028, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsbandung.com', 'Doctor', 'Dr. Dewi Sari', 'Rheumatologist', 'Female', '0812120018'),
	(1029, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsbandung.com', 'Doctor', 'Dr. Ahmad Rizky', 'Urologist', 'Male', '0812120019'),
	(1030, 5023, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsbandung.com', 'Doctor', 'Dr. Rika Damayanti', 'Hematologist', 'Female', '0812120020'),
	(1031, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsyogyakarta.com', 'Doctor', 'Dr. Bambang Sutrisno', 'Ophthalmologist', 'Male', '0812130011'),
	(1032, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsyogyakarta.com', 'Doctor', 'Dr. Ayu Setiawati', 'Allergist', 'Female', '0812130012'),
	(1033, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsyogyakarta.com', 'Doctor', 'Dr. Slamet Riyanto', 'Pulmonologist', 'Male', '0812130013'),
	(1034, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsyogyakarta.com', 'Doctor', 'Dr. Wulan Kusuma', 'Nephrologist', 'Female', '0812130014'),
	(1035, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsyogyakarta.com', 'Doctor', 'Dr. Hendra Wijaya', 'Orthopedic Surgeon', 'Male', '0812130015'),
	(1036, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsyogyakarta.com', 'Doctor', 'Dr. Rina Widya', 'Obstetrician', 'Female', '0812130016'),
	(1037, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsyogyakarta.com', 'Doctor', 'Dr. Andi Firmansyah', 'Otolaryngologist', 'Male', '0812130017'),
	(1038, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsyogyakarta.com', 'Doctor', 'Dr. Sari Amalia', 'Plastic Surgeon', 'Female', '0812130018'),
	(1039, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsyogyakarta.com', 'Doctor', 'Dr. Bambang Setiaji', 'Radiologist', 'Male', '0812130019'),
	(1040, 5024, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsyogyakarta.com', 'Doctor', 'Dr. Ratna Dewi', 'Anesthesiologist', 'Female', '0812130020'),
	(1041, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsmedan.com', 'Doctor', 'Dr. Ahmad Suryadi', 'Cardiologist', 'Male', '0812140011'),
	(1042, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsmedan.com', 'Doctor', 'Dr. Nurul Aisyah', 'Neurologist', 'Female', '0812140012'),
	(1043, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsmedan.com', 'Doctor', 'Dr. Hendra Pratama', 'Pediatrician', 'Male', '0812140013'),
	(1044, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsmedan.com', 'Doctor', 'Dr. Lina Wati', 'Oncologist', 'Female', '0812140014'),
	(1045, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsmedan.com', 'Doctor', 'Dr. Eko Wijaya', 'Dermatologist', 'Male', '0812140015'),
	(1046, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsmedan.com', 'Doctor', 'Dr. Rina Kurnia', 'Endocrinologist', 'Female', '0812140016'),
	(1047, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsmedan.com', 'Doctor', 'Dr. Wahyu Susanto', 'Gastroenterologist', 'Male', '0812140017'),
	(1048, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsmedan.com', 'Doctor', 'Dr. Dewi Puspita', 'Rheumatologist', 'Female', '0812140018'),
	(1049, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsmedan.com', 'Doctor', 'Dr. Ahmad Fauzi', 'Urologist', 'Male', '0812140019'),
	(1050, 5025, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsmedan.com', 'Doctor', 'Dr. Rika Amalia', 'Hematologist', 'Female', '0812140020'),
	(1051, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsdenpasar.com', 'Doctor', 'Dr. Budi Santoso', 'Ophthalmologist', 'Male', '0812150011'),
	(1052, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsdenpasar.com', 'Doctor', 'Dr. Dian Puspita', 'Allergist', 'Female', '0812150012'),
	(1053, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsdenpasar.com', 'Doctor', 'Dr. Yudi Saputra', 'Pulmonologist', 'Male', '0812150013'),
	(1054, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsdenpasar.com', 'Doctor', 'Dr. Maya Utami', 'Nephrologist', 'Female', '0812150014'),
	(1055, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsdenpasar.com', 'Doctor', 'Dr. Wawan Pratama', 'Orthopedic Surgeon', 'Male', '0812150015'),
	(1056, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsdenpasar.com', 'Doctor', 'Dr. Lestari Kurnia', 'Obstetrician', 'Female', '0812150016'),
	(1057, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsdenpasar.com', 'Doctor', 'Dr. Andi Susanto', 'Otolaryngologist', 'Male', '0812150017'),
	(1058, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsdenpasar.com', 'Doctor', 'Dr. Sari Amalia', 'Plastic Surgeon', 'Female', '0812150018'),
	(1059, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsdenpasar.com', 'Doctor', 'Dr. Bambang Wijaya', 'Radiologist', 'Male', '0812150019'),
	(1060, 5026, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsdenpasar.com', 'Doctor', 'Dr. Ratna Lestari', 'Anesthesiologist', 'Female', '0812150020'),
	(1061, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsmakassar.com', 'Doctor', 'Dr. Agus Pratama', 'Cardiologist', 'Male', '0812160011'),
	(1062, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsmakassar.com', 'Doctor', 'Dr. Dian Kurniawan', 'Neurologist', 'Female', '0812160012'),
	(1063, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsmakassar.com', 'Doctor', 'Dr. Wawan Purnama', 'Pediatrician', 'Male', '0812160013'),
	(1064, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsmakassar.com', 'Doctor', 'Dr. Siti Lestari', 'Oncologist', 'Female', '0812160014'),
	(1065, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsmakassar.com', 'Doctor', 'Dr. Eko Wijaya', 'Dermatologist', 'Male', '0812160015'),
	(1066, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsmakassar.com', 'Doctor', 'Dr. Nina Amalia', 'Endocrinologist', 'Female', '0812160016'),
	(1067, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsmakassar.com', 'Doctor', 'Dr. Wahyu Santoso', 'Gastroenterologist', 'Male', '0812160017'),
	(1068, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsmakassar.com', 'Doctor', 'Dr. Dewi Putri', 'Rheumatologist', 'Female', '0812160018'),
	(1069, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsmakassar.com', 'Doctor', 'Dr. Ahmad Riyadi', 'Urologist', 'Male', '0812160019'),
	(1070, 5027, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsmakassar.com', 'Doctor', 'Dr. Rika Puspita', 'Hematologist', 'Female', '0812160020'),
	(1071, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rssemarang.com', 'Doctor', 'Dr. Agus Wijaya', 'Cardiologist', 'Male', '0812170011'),
	(1072, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rssemarang.com', 'Doctor', 'Dr. Budi Lestari', 'Neurologist', 'Male', '0812170012'),
	(1073, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rssemarang.com', 'Doctor', 'Dr. Siti Purnama', 'Pediatrician', 'Female', '0812170013'),
	(1074, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rssemarang.com', 'Doctor', 'Dr. Rina Suryadi', 'Oncologist', 'Female', '0812170014'),
	(1075, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rssemarang.com', 'Doctor', 'Dr. Eko Hartono', 'Dermatologist', 'Male', '0812170015'),
	(1076, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rssemarang.com', 'Doctor', 'Dr. Nina Amalia', 'Endocrinologist', 'Female', '0812170016'),
	(1077, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rssemarang.com', 'Doctor', 'Dr. Wahyu Pratama', 'Gastroenterologist', 'Male', '0812170017'),
	(1078, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rssemarang.com', 'Doctor', 'Dr. Dewi Kusuma', 'Rheumatologist', 'Female', '0812170018'),
	(1079, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rssemarang.com', 'Doctor', 'Dr. Ahmad Setiawan', 'Urologist', 'Male', '0812170019'),
	(1080, 5028, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rssemarang.com', 'Doctor', 'Dr. Rika Lestari', 'Hematologist', 'Female', '0812170020'),
	(1081, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rspalembang.com', 'Doctor', 'Dr. Bambang Suryadi', 'Cardiologist', 'Male', '0812180011'),
	(1082, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rspalembang.com', 'Doctor', 'Dr. Dian Prasetyo', 'Neurologist', 'Female', '0812180012'),
	(1083, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rspalembang.com', 'Doctor', 'Dr. Wawan Putri', 'Pediatrician', 'Male', '0812180013'),
	(1084, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rspalembang.com', 'Doctor', 'Dr. Siti Amalia', 'Oncologist', 'Female', '0812180014'),
	(1085, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rspalembang.com', 'Doctor', 'Dr. Eko Haryanto', 'Dermatologist', 'Male', '0812180015'),
	(1086, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rspalembang.com', 'Doctor', 'Dr. Rina Pratama', 'Endocrinologist', 'Female', '0812180016'),
	(1087, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rspalembang.com', 'Doctor', 'Dr. Wahyu Santoso', 'Gastroenterologist', 'Male', '0812180017'),
	(1088, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rspalembang.com', 'Doctor', 'Dr. Dewi Wulandari', 'Rheumatologist', 'Female', '0812180018'),
	(1089, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rspalembang.com', 'Doctor', 'Dr. Ahmad Kusuma', 'Urologist', 'Male', '0812180019'),
	(1090, 5029, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rspalembang.com', 'Doctor', 'Dr. Rika Hartono', 'Hematologist', 'Female', '0812180020'),
	(1091, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter1@rsbalikpapan.com', 'Doctor', 'Dr. Agus Riyadi', 'Cardiologist', 'Male', '0812190011'),
	(1092, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter2@rsbalikpapan.com', 'Doctor', 'Dr. Budi Wijaya', 'Neurologist', 'Male', '0812190012'),
	(1093, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter3@rsbalikpapan.com', 'Doctor', 'Dr. Siti Amalia', 'Pediatrician', 'Female', '0812190013'),
	(1094, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter4@rsbalikpapan.com', 'Doctor', 'Dr. Rina Putri', 'Oncologist', 'Female', '0812190014'),
	(1095, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter5@rsbalikpapan.com', 'Doctor', 'Dr. Eko Pratama', 'Dermatologist', 'Male', '0812190015'),
	(1096, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter6@rsbalikpapan.com', 'Doctor', 'Dr. Nina Purnama', 'Endocrinologist', 'Female', '0812190016'),
	(1097, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter7@rsbalikpapan.com', 'Doctor', 'Dr. Wahyu Hartono', 'Gastroenterologist', 'Male', '0812190017'),
	(1098, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter8@rsbalikpapan.com', 'Doctor', 'Dr. Dewi Amalia', 'Rheumatologist', 'Female', '0812190018'),
	(1099, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter9@rsbalikpapan.com', 'Doctor', 'Dr. Ahmad Suryadi', 'Urologist', 'Male', '0812190019'),
	(1100, 5030, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'dokter10@rsbalikpapan.com', 'Doctor', 'Dr. Rika Wijaya', 'Hematologist', 'Female', '0812190020');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(3101, '1234567890123456', 5021, 1001, 7, '2024-05-01', 'Rawat Inap', 'Obstruksi usus besar'),
(3102, '1234567890123466', 5021, 1001, 7, '2024-05-12', 'Rawat Inap', 'Asma eksaserbasi'),
(3103, '1234567890123471', 5021, 1001, 7, '2024-05-15', 'Pemeriksaan', 'Gagal ginjal kronis stadium akhir'),
(3104, '1234567890123460', 5021, 1001, 7, '2024-05-20', 'Pemeriksaan', 'Stroke iskemik akut'),
(3105, '1234567890123470', 5021, 1001, 7, '2024-05-21', 'Rawat Inap', 'Stroke iskemik akut'),
(3106, '1234567890123479', 5021, 1001, 7, '2024-05-29', 'Pemeriksaan', 'Stroke iskemik akut'),
(3107, '1234567890123498', 5021, 1001, 7, '2024-05-01', 'Rawat Inap', 'Stroke iskemik akut'),
(3108, '1234567890123476', 5021, 1001, 8, '2024-05-12', 'Rawat Inap', 'Apendisitis akut'),
(3109, '1234567890123488', 5021, 1001, 8, '2024-05-15', 'Pemeriksaan', 'Gagal jantung kongestif'),
(3110, '1234567890123482', 5021, 1001, 9, '2024-05-20', 'Pemeriksaan', 'Gagal jantung kongestif'),
(3111, '1234567890123480', 5021, 1001, 9, '2024-05-21', 'Rawat Inap', 'Gagal ginjal kronis stadium akhir'),
(3112, '1234567890123484', 5021, 1001, 9, '2024-05-29', 'Pemeriksaan', 'Asma eksaserbasi berat'),
(3113, '1234567890123491', 5021, 1001, 7, '2024-06-01', 'Rawat Inap', 'Bronkitis akut'),
(3114, '1234567890123492', 5021, 1001, 8, '2024-06-02', 'Rawat Inap', 'Asma eksaserbasi berat'),
(3115, '1234567890123493', 5021, 1001, 9, '2024-06-03', 'Pemeriksaan', 'Gagal jantung kongestif'),
(3116, '1234567890123494', 5021, 1001, 7, '2024-06-04', 'Pemeriksaan', 'Diabetes melitus tipe 2 tidak terkontrol'),
(3117, '1234567890123495', 5021, 1001, 8, '2024-06-05', 'Rawat Inap', 'Hipertensi esensial'),
(3118, '1234567890123496', 5021, 1001, 9, '2024-06-06', 'Pemeriksaan', 'Gagal ginjal kronis stadium akhir'),
(3119, '1234567890123497', 5021, 1001, 7, '2024-06-07', 'Rawat Inap', 'Pneumonia komunitas berat'),
(3120, '1234567890123499', 5021, 1001, 8, '2024-06-08', 'Pemeriksaan', 'Infeksi saluran kemih berulang'),
(3121, '1234567890123500', 5021, 1002, 9, '2024-06-09', 'Rawat Inap', 'Stroke iskemik akut'),
(3122, '1234567890123501', 5021, 1002, 7, '2024-06-10', 'Pemeriksaan', 'Apendisitis akut'),
(3123, '1234567890123502', 5021, 1002, 8, '2024-06-11', 'Rawat Inap', 'Gastroenteritis akut'),
(3124, '1234567890123503', 5021, 1002, 9, '2024-06-12', 'Pemeriksaan', 'Kolesistitis akut'),
(3125, '1234567890123504', 5021, 1002, 7, '2024-06-13', 'Rawat Inap', 'Pankreatitis akut'),
(3126, '1234567890123505', 5021, 1002, 8, '2024-06-14', 'Pemeriksaan', 'Kanker paru-paru stadium lanjut'),
(3127, '1234567890123506', 5021, 1002, 9, '2024-06-15', 'Rawat Inap', 'Anemia defisiensi besi berat'),
(3128, '1234567890123507', 5021, 1002, 7, '2024-06-16', 'Pemeriksaan', 'Trombositopenia idiopatik'),
(3129, '1234567890123508', 5021, 1002, 8, '2024-06-17', 'Rawat Inap', 'Hepatitis B kronis aktif'),
(3130, '1234567890123509', 5021, 1002, 9, '2024-06-18', 'Pemeriksaan', 'HIV/AIDS stadium lanjut'),
(3131, '1234567890123510', 5021, 1002, 7, '2024-06-19', 'Rawat Inap', 'Lupus eritematosus sistemik dengan komplikasi ginjal'),
(3132, '1234567890123511', 5021, 1002, 8, '2024-06-20', 'Pemeriksaan', 'Psoriasis plak berat'),
(3133, '1234567890123512', 5021, 1002, 9, '2024-06-21', 'Rawat Inap', 'Artritis reumatoid aktif'),
(3134, '1234567890123513', 5021, 1002, 7, '2024-06-22', 'Pemeriksaan', 'Obstruksi usus besar'),
(3135, '1234567890123514', 5021, 1002, 8, '2024-06-23', 'Rawat Inap', 'Aneurisma aorta abdominalis'),
(3136, '1234567890123515', 5021, 1002, 9, '2024-06-24', 'Pemeriksaan', 'Spondilitis ankilosa'),
(3137, '1234567890123503', 5021, 1002, 7, '2024-06-25', 'Rawat Inap', 'Sindrom nefrotik berat'),
(3138, '1234567890123503', 5021, 1002, 8, '2024-06-26', 'Pemeriksaan', 'Sindrom Guillain-Barré'),
(3139, '1234567890123503', 5021, 1002, 9, '2024-06-27', 'Rawat Inap', 'Emboli paru akut'),
(3140, '1234567890123503', 5021, 1002, 7, '2024-06-28', 'Pemeriksaan', 'Miokarditis akut'),
(3141, '1234567890123503', 5021, 1002, 8, '2024-06-29', 'Rawat Inap', 'Endokarditis infektif'),
(3142, '1234567890123503', 5021, 1002, 9, '2024-06-30', 'Pemeriksaan', 'Tuberkulosis paru aktif'),
(3143, '1234567890123487', 5021, 1003, 7, '2024-07-01', 'Rawat Inap', 'Cirrhosis hati dekompensata'),
(3144, '1234567890123487', 5021, 1003, 8, '2024-07-02', 'Pemeriksaan', 'Kanker kolorektal stadium 4'),
(3145, '1234567890123487', 5021, 1003, 9, '2024-07-03', 'Rawat Inap', 'Glomerulonefritis akut'),
(3146, '1234567890123487', 5021, 1003, 7, '2024-07-04', 'Pemeriksaan', 'Epilepsi tidak terkontrol'),
(3147, '1234567890123487', 5021, 1003, 8, '2024-07-05', 'Rawat Inap', 'Kanker payudara stadium lanjut'),
(3148, '1234567890123487', 5021, 1003, 9, '2024-07-06', 'Pemeriksaan', 'Kanker pankreas stadium lanjut'),
(3149, '1234567890123496', 5021, 1003, 7, '2024-07-07', 'Rawat Inap', 'Hepatitis C kronis'),
(3150, '1234567890123496', 5021, 1004, 8, '2024-07-08', 'Pemeriksaan', 'Asma bronkial akut'),
(3151, '1234567890123496', 5021, 1004, 9, '2024-07-09', 'Rawat Inap', 'Alergi makanan parah'),
(3152, '1234567890123496', 5021, 1004, 7, '2024-07-10', 'Pemeriksaan', 'Kanker prostat stadium lanjut'),
(3153, '1234567890123496', 5021, 1004, 8, '2024-07-11', 'Rawat Inap', 'Limfoma non-Hodgkin'),
(3154, '1234567890123496', 5021, 1005, 9, '2024-07-12', 'Pemeriksaan', 'Multiple sclerosis'),
(3155, '1234567890123496', 5021, 1005, 7, '2024-07-13', 'Rawat Inap', 'Kanker kandung kemih'),
(3156, '1234567890123496', 5021, 1005, 8, '2024-07-14', 'Pemeriksaan', 'Limfoma non-Hodgkin'),
(3157, '1234567890123489', 5021, 1006, 9, '2024-07-15', 'Rawat Inap', 'Trombosis vena dalam'),
(3158, '1234567890123489', 5021, 1006, 7, '2024-07-16', 'Pemeriksaan', 'Sindrom koroner akut'),
(3159, '1234567890123489', 5021, 1006, 8, '2024-07-17', 'Rawat Inap', 'Cholangitis akut'),
(3160, '1234567890123489', 5021, 1007, 9, '2024-07-18', 'Pemeriksaan', 'Gagal napas akut'),
(3161, '1234567890123489', 5021, 1007, 7, '2024-07-19', 'Rawat Inap', 'Osteomielitis akut'),
(3162, '1234567890123489', 5021, 1007, 8, '2024-07-20', 'Pemeriksaan', 'Ensefalitis virus'),
(3163, '1234567890123489', 5021, 1008, 9, '2024-07-21', 'Rawat Inap', 'Pancreatitis kronis'),
(3164, '1234567890123489', 5021, 1008, 7, '2024-07-22', 'Pemeriksaan', 'Osteoporosis dengan fraktur vertebra'),
(3165, '1234567890123489', 5021, 1008, 8, '2024-07-23', 'Rawat Inap', 'Tumor otak ganas'),
(3166, '1234567890123456', 5021, 1008, 9, '2024-07-24', 'Pemeriksaan', 'Saraf keempat palsu'),
(3167, '1234567890123456', 5021, 1009, 7, '2024-07-25', 'Rawat Inap', 'Kusta multibasiler'),
(3168, '1234567890123456', 5021, 1009, 8, '2024-07-26', 'Pemeriksaan', 'Ensefalopati hepatikum'),
(3169, '1234567890123456', 5021, 1009, 9, '2024-07-27', 'Rawat Inap', 'Sepsis berat'),
(3170, '1234567890123456', 5021, 1009, 7, '2024-07-28', 'Pemeriksaan', 'Pneumotoraks spontan'),
(3171, '1234567890123456', 5021, 1010, 8, '2024-07-29', 'Rawat Inap', 'Leukemia limfositik kronis');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(3201, '1234567890123456', 5023, 1021, 7, '2024-05-01', 'Rawat Inap', 'Obstruksi usus besar'),
(3202, '1234567890123466', 5023, 1021, 7, '2024-05-12', 'Rawat Inap', 'Asma eksaserbasi'),
(3203, '1234567890123471', 5023, 1021, 7, '2024-05-15', 'Pemeriksaan', 'Gagal ginjal kronis'),
(3204, '1234567890123460', 5022, 1011, 7, '2024-05-20', 'Pemeriksaan', 'Stroke iskemik akut'),
(3205, '1234567890123470', 5022, 1011, 7, '2024-05-21', 'Rawat Inap', 'Stroke iskemik akut'),
(3206, '1234567890123479', 5022, 1011, 7, '2024-05-29', 'Pemeriksaan', 'Stroke iskemik akut'),
(3207, '1234567890123498', 5023, 1021, 7, '2024-05-01', 'Rawat Inap', 'Stroke iskemik akut'),
(3208, '1234567890123476', 5023, 1021, 8, '2024-05-12', 'Rawat Inap', 'Apendisitis akut'),
(3209, '1234567890123488', 5023, 1021, 8, '2024-05-15', 'Pemeriksaan', 'Gagal jantung kongestif'),
(3210, '1234567890123482', 5023, 1021, 9, '2024-05-20', 'Pemeriksaan', 'Gagal jantung kongestif'),
(3211, '1234567890123480', 5023, 1022, 9, '2024-05-21', 'Rawat Inap', 'Gagal ginjal kronis stadium akhir'),
(3212, '1234567890123484', 5023, 1022, 9, '2024-05-29', 'Pemeriksaan', 'Asma eksaserbasi berat'),
(3213, '1234567890123491', 5024, 1031, 7, '2024-06-01', 'Rawat Inap', 'Bronkitis akut'),
(3214, '1234567890123492', 5024, 1032, 8, '2024-06-02', 'Rawat Inap', 'Asma eksaserbasi berat'),
(3215, '1234567890123493', 5024, 1032, 9, '2024-06-03', 'Pemeriksaan', 'Gagal jantung kongestif'),
(3216, '1234567890123494', 5024, 1031, 7, '2024-06-04', 'Pemeriksaan', 'Diabetes melitus tipe 2 tidak terkontrol'),
(3217, '1234567890123495', 5024, 1031, 8, '2024-06-05', 'Rawat Inap', 'Hipertensi esensial'),
(3218, '1234567890123496', 5024, 1031, 9, '2024-06-06', 'Pemeriksaan', 'Gagal ginjal kronis stadium akhir'),
(3219, '1234567890123497', 5024, 1031, 7, '2024-06-07', 'Rawat Inap', 'Pneumonia komunitas berat'),
(3220, '1234567890123499', 5024, 1041, 8, '2024-06-08', 'Pemeriksaan', 'Infeksi saluran kemih berulang'),
(3221, '1234567890123500', 5025, 1042, 9, '2024-06-09', 'Rawat Inap', 'Stroke iskemik akut'),
(3222, '1234567890123501', 5025, 1045, 7, '2024-06-10', 'Pemeriksaan', 'Apendisitis akut'),
(3223, '1234567890123502', 5025, 1044, 8, '2024-06-11', 'Rawat Inap', 'Gastroenteritis akut'),
(3224, '1234567890123503', 5025, 1041, 9, '2024-06-12', 'Pemeriksaan', 'Kolesistitis akut'),
(3225, '1234567890123504', 5025, 1041, 7, '2024-06-13', 'Rawat Inap', 'Pankreatitis akut'),
(3226, '1234567890123505', 5025, 1041, 8, '2024-06-14', 'Pemeriksaan', 'Kanker paru-paru stadium lanjut'),
(3227, '1234567890123506', 5025, 1011, 9, '2024-06-15', 'Rawat Inap', 'Anemia defisiensi besi berat'),
(3228, '1234567890123507', 5025, 1041, 7, '2024-06-16', 'Pemeriksaan', 'Trombositopenia idiopatik'),
(3229, '1234567890123508', 5026, 1051, 8, '2024-06-17', 'Rawat Inap', 'Hepatitis B kronis aktif'),
(3230, '1234567890123509', 5026, 1051, 9, '2024-06-18', 'Pemeriksaan', 'HIV/AIDS stadium lanjut'),
(3231, '1234567890123510', 5026, 1051, 7, '2024-06-19', 'Rawat Inap', 'Lupus eritematosus sistemik dengan komplikasi ginjal'),
(3232, '1234567890123511', 5026, 1051, 8, '2024-06-20', 'Pemeriksaan', 'Psoriasis plak berat'),
(3233, '1234567890123512', 5026, 1051, 9, '2024-06-21', 'Rawat Inap', 'Artritis reumatoid aktif'),
(3234, '1234567890123513', 5026, 1051, 7, '2024-06-22', 'Pemeriksaan', 'Obstruksi usus besar'),
(3235, '1234567890123514', 5026, 1051, 8, '2024-06-23', 'Rawat Inap', 'Aneurisma aorta abdominalis'),
(3236, '1234567890123515', 5026, 1051, 9, '2024-06-24', 'Pemeriksaan', 'Spondilitis ankilosa'),
(3237, '1234567890123503', 5027, 1061, 7, '2024-06-25', 'Rawat Inap', 'Sindrom nefrotik berat'),
(3238, '1234567890123503', 5027, 1061, 8, '2024-06-26', 'Pemeriksaan', 'Sindrom Guillain-Barré'),
(3239, '1234567890123503', 5027, 1061, 9, '2024-06-27', 'Rawat Inap', 'Emboli paru akut'),
(3240, '1234567890123503', 5027, 1061, 7, '2024-06-28', 'Pemeriksaan', 'Miokarditis akut'),
(3241, '1234567890123503', 5027, 1061, 8, '2024-06-29', 'Rawat Inap', 'Endokarditis infektif'),
(3242, '1234567890123503', 5027, 1061, 9, '2024-06-30', 'Pemeriksaan', 'Tuberkulosis paru aktif'),
(3243, '1234567890123487', 5027, 1061, 7, '2024-07-01', 'Rawat Inap', 'Cirrhosis hati dekompensata'),
(3244, '1234567890123487', 5028, 1073, 8, '2024-07-02', 'Pemeriksaan', 'Kanker kolorektal stadium 4'),
(3245, '1234567890123487', 5028, 1073, 9, '2024-07-03', 'Rawat Inap', 'Glomerulonefritis akut'),
(3246, '1234567890123487', 5028, 1071, 7, '2024-07-04', 'Pemeriksaan', 'Epilepsi tidak terkontrol'),
(3247, '1234567890123487', 5028, 1071, 8, '2024-07-05', 'Rawat Inap', 'Kanker payudara stadium lanjut'),
(3248, '1234567890123487', 5029, 1082, 9, '2024-07-06', 'Pemeriksaan', 'Kanker pankreas stadium lanjut'),
(3249, '1234567890123496', 5029, 1081, 7, '2024-07-07', 'Rawat Inap', 'Hepatitis C kronis'),
(3250, '1234567890123496', 5029, 1081, 8, '2024-07-08', 'Pemeriksaan', 'Asma bronkial akut'),
(3251, '1234567890123496', 5029, 1081, 9, '2024-07-09', 'Rawat Inap', 'Alergi makanan parah'),
(3252, '1234567890123496', 5030, 1091, 7, '2024-07-10', 'Pemeriksaan', 'Kanker prostat stadium lanjut'),
(3253, '1234567890123496', 5030, 1091, 8, '2024-07-11', 'Rawat Inap', 'Limfoma non-Hodgkin'),
(3254, '1234567890123496', 5030, 1092, 9, '2024-07-12', 'Pemeriksaan', 'Multiple sclerosis'),
(3255, '1234567890123496', 5022, 1015, 7, '2024-07-13', 'Rawat Inap', 'Kanker kandung kemih'),
(3256, '1234567890123496', 5022, 1015, 8, '2024-07-14', 'Pemeriksaan', 'Limfoma non-Hodgkin'),
(3257, '1234567890123489', 5022, 1016, 9, '2024-07-15', 'Rawat Inap', 'Trombosis vena dalam'),
(3258, '1234567890123489', 5022, 1016, 7, '2024-07-16', 'Pemeriksaan', 'Sindrom koroner akut'),
(3259, '1234567890123489', 5022, 1016, 8, '2024-07-17', 'Rawat Inap', 'Cholangitis akut'),
(3260, '1234567890123489', 5022, 1017, 9, '2024-07-18', 'Pemeriksaan', 'Gagal napas akut'),
(3261, '1234567890123489', 5022, 1017, 7, '2024-07-19', 'Rawat Inap', 'Osteomielitis akut'),
(3262, '1234567890123489', 5022, 1017, 8, '2024-07-20', 'Pemeriksaan', 'Ensefalitis virus'),
(3263, '1234567890123489', 5022, 1018, 9, '2024-07-21', 'Rawat Inap', 'Pancreatitis kronis'),
(3264, '1234567890123489', 5022, 1018, 7, '2024-07-22', 'Pemeriksaan', 'Osteoporosis dengan fraktur vertebra'),
(3265, '1234567890123489', 5022, 1018, 8, '2024-07-23', 'Rawat Inap', 'Tumor otak ganas'),
(3266, '1234567890123456', 5022, 1018, 9, '2024-07-24', 'Pemeriksaan', 'Saraf keempat palsu'),
(3267, '1234567890123456', 5022, 1019, 7, '2024-07-25', 'Rawat Inap', 'Kusta multibasiler'),
(3268, '1234567890123456', 5022, 1019, 8, '2024-07-26', 'Pemeriksaan', 'Ensefalopati hepatikum'),
(3269, '1234567890123456', 5022, 1019, 9, '2024-07-27', 'Rawat Inap', 'Sepsis berat'),
(3270, '1234567890123456', 5022, 1019, 7, '2024-07-28', 'Pemeriksaan', 'Pneumotoraks spontan'),
(3271, '1234567890123456', 5022, 1020, 8, '2024-07-29', 'Rawat Inap', 'Leukemia limfositik kronis');

	CREATE INDEX idx_tm_nama_tm ON Tenaga_Medis (Nama_TenagaMedis);
	CREATE INDEX idx_tm_spesialisasi ON Tenaga_Medis (Spesialisasi);
	

	CREATE INDEX idx_rs_kota ON Rumah_Sakit(Kota);
	CREATE INDEX idx_rs_nama_rs ON Rumah_Sakit(Nama_RumahSakit);

	CREATE INDEX idx_ps_nama_ps ON Pasien (Nama_Pasien);
	CREATE INDEX idx_ps_alamat ON Pasien (Alamat);

	CREATE INDEX idx_riwayat_jl ON Riwayat (Jenis_Layanan);
    
-- 	CREATE INDEX idx_emaillog_wk ON email_log (waktu_kirim);

	SELECT * FROM pasien;
	SELECT spesialisasi FROM tenaga_medis;
	SELECT tanggal_riwayat FROM riwayat;


	CREATE INDEX idx_riwayat_tanggal ON Riwayat (tanggal_riwayat);
	CREATE INDEX idx_riwayat_NIK ON Riwayat (NIK);

    CREATE INDEX idx_tm_id ON Tenaga_Medis (tenagamedis_id);
    
    
SELECT *
FROM pasien P
JOIN riwayat R ON P.NIK = R.NIK
WHERE R.tenagamedis_id = 115;


	SELECT * FROM riwayat WHERE NIK = 1234;

	SELECT Nama_TenagaMedis FROM Tenaga_Medis;
-- 	SELECT Spesialisasi FROM Tenaga_Medis;

-- 	SELECT Kota FROM Rumah_Sakit;
-- 	SELECT Nama_RumahSakit FROM Rumah_Sakit;

-- 	SELECT Nama_Pasien FROM Pasien;
-- 	SELECT Alamat FROM Pasien;

-- 	SELECT Jenis_Layanan From Riwayat;

-- 	DROP INDEX idx_ps_nama_ps ON Pasien;

-- 	SELECT Nama_Pasien FROM Pasien;

-- 	EXPLAIN SELECT Nama_Pasien FROM Pasien;


SELECT * FROM tenaga_medis;

SELECT * FROM pasien;