	create database if not exists db68;

	use db68;

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

				-- Tabel obat
		CREATE TABLE obat (
			obat_id INT PRIMARY KEY,
			nama_obat VARCHAR(100),
			deskripsi VARCHAR(255)
		);


		CREATE TABLE riwayat (
			riwayat_id INT PRIMARY KEY,
			NIK VARCHAR(10),
			rumahsakit_id INT,
			tenagamedis_id INT,
            obat_id INT,
			tanggal_riwayat DATE,
			jenis_layanan VARCHAR(100),
			keterangan_penyakit VARCHAR(255),
			FOREIGN KEY (NIK) REFERENCES pasien(NIK),
			FOREIGN KEY (rumahsakit_id) REFERENCES rumah_sakit(rumahsakit_id),
			FOREIGN KEY (tenagamedis_id) REFERENCES tenaga_medis(tenagamedis_id),
            FOREIGN KEY (obat_id) REFERENCES obat(obat_id)
		);


	-- Buat tabel email_log
CREATE TABLE email_log (
 		Log_ID INT AUTO_INCREMENT PRIMARY KEY,
		NIK VARCHAR(10),
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
    IN p_NIK VARCHAR(10),
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
	INSERT INTO pasien (NIK, password, email, usertype, nama_pasien, Tanggal_Lahir, alamat, tinggi, berat_badan, golongan_darah, alergi, no_telepon_pasien, jenis_kelamin) 
	VALUES 
	('1432', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
    ('1234', '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
    ('1345', 'password123', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
    ('12346', 'password123', 'pasien1@example.com', 'pasien', 'John Doe', '1985-01-15', 'Alamat Pasien 1', 175, 70, 'O', 'Debu', '081234567890', 'Laki-laki'),
	('1234567890', 'password456', 'pasien2@example.com', 'pasien', 'Jane Smith', '1990-02-20', 'Alamat Pasien 2', 160, 55, 'A', 'Kacang', '082345678901', 'Perempuan'),
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
	
    INSERT INTO Rumah_Sakit (rumahsakit_id, nama_rumahsakit, alamat, no_telepon, kota) 
	VALUES 
	(502522, 'Rumah Sakit Harapan Kita', 'Jl. Karawaci', '081122334455', 'Tangerang');
    
	INSERT INTO Rumah_Sakit (rumahsakit_id, nama_rumahsakit, alamat, no_telepon, kota) 
	VALUES 
	(502523, 'Rumah Sakit Bintaro Premier', 'Jl. Bintaro', '081122334455', 'Tangerang');
    
	-- Insert data ke dalam tabel tenaga_medis
	INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_Kelamin, no_telepon_tenagamedis) 
	VALUES 
	(101, 1, 'passmed123', 'medis1@example.com', 'tenaga medis', 'Dr. Johnson', 'Spesialis 1', 'Laki-laki', '081011223344'),
	(102, 2, 'passmed456', 'medis2@example.com', 'tenaga medis', 'Dr. Smith', 'Spesialis 2', 'Perempuan', '082122334455'),
	(103, 3, 'passmed789', 'medis3@example.com', 'tenaga medis', 'Dr. Brown', 'Spesialis 3', 'Laki-laki', '083233445566'),
	(104, 4, 'passmedabc', 'medis4@example.com', 'tenaga medis', 'Dr. Davis', 'Spesialis 4', 'Perempuan', '084344556677'),
	(105, 5, 'passmeddef', 'medis5@example.com', 'tenaga medis', 'Dr. Lee', 'Spesialis 5', 'Laki-laki', '085455667788');
	
    
INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_kelamin, no_telepon_tenagamedis) 
VALUES 
    (111, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis111@example.com', 'tenaga medis', 'Dr. John Doe', 'Ortopedi', 'Laki-laki', '081011223344'),
    (112, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis112@example.com', 'tenaga medis', 'Dr. Jane Smith', 'Kardiologi', 'Perempuan', '082011223344'),
    (113, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis113@example.com', 'tenaga medis', 'Dr. Michael Brown', 'Neurologi', 'Laki-laki', '083011223344'),
    (114, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis114@example.com', 'tenaga medis', 'Dr. Emily Davis', 'Pediatri', 'Perempuan', '084011223344'),
    (115, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis115@example.com', 'tenaga medis', 'Dr. William Johnson', 'Dermatologi', 'Laki-laki', '085011223344'),
    (116, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis116@example.com', 'tenaga medis', 'Dr. Olivia Wilson', 'Oftalmologi', 'Perempuan', '086011223344'),
    (117, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis117@example.com', 'tenaga medis', 'Dr. James Moore', 'Ginekologi', 'Laki-laki', '087011223344'),
    (118, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis118@example.com', 'tenaga medis', 'Dr. Sophia Taylor', 'Onkologi', 'Perempuan', '088011223344'),
    (119, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis119@example.com', 'tenaga medis', 'Dr. Benjamin Anderson', 'Psikiatri', 'Laki-laki', '089011223344'),
    (120, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis120@example.com', 'tenaga medis', 'Dr. Amelia Martinez', 'Urologi', 'Perempuan', '080011223344'),
    (121, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis121@example.com', 'tenaga medis', 'Dr. Elijah Thomas', 'Gastroenterologi', 'Laki-laki', '081122334455'),
    (122, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis122@example.com', 'tenaga medis', 'Dr. Mia Jackson', 'Endokrinologi', 'Perempuan', '082122334455'),
    (123, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis123@example.com', 'tenaga medis', 'Dr. Daniel White', 'Hematologi', 'Laki-laki', '083122334455'),
    (124, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis124@example.com', 'tenaga medis', 'Dr. Charlotte Harris', 'Nefrologi', 'Perempuan', '084122334455'),
    (125, 502522, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis125@example.com', 'tenaga medis', 'Dr. Lucas Martin', 'Pulmonologi', 'Laki-laki', '085122334455');

INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_kelamin, no_telepon_tenagamedis) 
VALUES 
    (131, 502523, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis111@example.com', 'tenaga medis', 'Dr. A', 'Ortopedi', 'Laki-laki', '081011223344'),
    (132, 502523, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis112@example.com', 'tenaga medis', 'Dr. B', 'Kardiologi', 'Perempuan', '082011223344'),
    (133, 502523, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis113@example.com', 'tenaga medis', 'Dr. C', 'Neurologi', 'Laki-laki', '083011223344');

INSERT INTO tenaga_medis (tenagamedis_id, rumahsakit_id, password, email, usertype, nama_tenagamedis, spesialisasi, jenis_Kelamin, no_telepon_tenagamedis) 
	VALUES 
	(1004, 1, '$2y$12$gTcfD83ekLjc6BdJuHlHYuDKTaDjNy38p2isFH7CBhndR/P8e96AC', 'medis1@example.com', 'tenaga medis', 'Dr. Naufal', 'Spesialis 1', 'Laki-laki', '081011223344');

	-- Insert data ke dalam tabel obat
INSERT INTO obat (obat_id, nama_obat, deskripsi) VALUES
(1, 'Paracetamol', 'Obat penurun demam dan pereda nyeri'),
(2, 'Ibuprofen', 'Obat anti-inflamasi nonsteroid'),
(3, 'Amoxicillin', 'Antibiotik untuk infeksi bakteri'),
(4, 'Ranitidine', 'Obat untuk gangguan pencernaan'),
(5, 'Cetirizine', 'Antihistamin untuk alergi'),
(6, 'Salbutamol', 'Obat untuk asma'),
(7, 'Metformin', 'Obat untuk diabetes'),
(8, 'Atorvastatin', 'Obat untuk kolesterol tinggi'),
(9, 'Omeprazole', 'Obat untuk tukak lambung'),
(10, 'Amlodipine', 'Obat untuk tekanan darah tinggi'),
(11, 'Ciprofloxacin', 'Antibiotik untuk infeksi bakteri'),
(12, 'Levothyroxine', 'Obat untuk hipotiroidisme');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(3, '3456789012', 3, 103, 1, '2024-05-03', 'Operasi', 'Patah tulang'),
(4, '4567890123', 4, 104, 2, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(5, '5678901234', 5, 105, 2, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(6, '1234567890', 1, 101, 2, '2024-05-01', 'Operasi', 'Flu'),
(7, '1234', 4, 104, 2, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(8, '1234567890', 5, 105, 2, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(9, '1234567890', 4, 104, 2, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(10, '1234567890', 5, 105, 2, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(11, '1234567890', 1, 101, 2, '2024-05-01', 'Rawat Inap', 'Flu');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(3001, '1432', 3, 103, 3, '2024-05-03', 'Operasi', 'Patah tulang'),
(3002, '1432', 4, 104, 3, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(3003, '1432', 5, 105, 3, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(3004, '1432', 1, 101, 3, '2024-05-01', 'Operasi', 'Flu'),
(3005, '1432', 4, 104, 3, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(3006, '1432', 5, 105, 3, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(3010, '1432', 4, 104, 3, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(3008, '1432', 5, 105, 3, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(3009, '1432', 1, 101, 3, '2024-05-01', 'Rawat Inap', 'Flu');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(1010, '1234567890', 502522, 103, 4, '2024-05-03', 'Operasi', 'Patah tulang'),
(2008, '1234567890', 502522, 104, 4, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(3007, '1234567890', 502522, 105, 4, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(4006, '1234567890', 502522, 101, 4, '2024-05-01', 'Operasi', 'Flu'),
(5005, '1234567890', 502522, 104, 4, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(1004, '3456789012', 502522, 105, 4, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(1003, '3456789012', 502522, 104, 4, '2024-05-04', 'Pemeriksaan', 'Sakit perut'),
(1002, '3456789012', 502522, 105, 4, '2024-05-05', 'Rawat Inap', 'Luka bakar'),
(1001, '3456789012', 502522, 101, 4, '2024-05-01', 'Rawat Inap', 'Flu');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(101, '3456789012', 3, 115, 5, '2024-05-03', 'Operasi', 'Patah tulang');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(102, '3456789012', 3, 115, 6, '2024-05-03', 'Operasi', 'Patah tulang'),
(103, '1234567890', 3, 115, 6, '2024-05-04', 'Konsultasi', 'Demam'),
(104, '1234567890', 3, 115, 6, '2024-05-05', 'Pemeriksaan', 'Flu'),
(105, '3456789012', 3, 115, 6, '2024-05-06', 'Operasi Darurat', 'Kecelakaan'),
(106, '1234', 3, 115, 6, '2024-05-07', 'Operasi', 'Patah tangan'),
(107, '3456789012', 3, 115, 6, '2024-05-08', 'Rawat Inap', 'Infeksi'),
(108, '1234', 3, 115, 6, '2024-05-09', 'Konsultasi', 'Sakit perut');

INSERT INTO riwayat (riwayat_id, NIK, rumahsakit_id, tenagamedis_id, obat_id, tanggal_riwayat, jenis_layanan, keterangan_penyakit)
VALUES
(31, '1345', 1, 101, 7, '2024-05-01', 'Rawat Inap', 'Flu'),
(30, '1345', 1, 101, 7, '2024-05-12', 'Rawat Inap', 'Flu'),
(32, '1345', 2, 102, 7, '2024-05-15', 'Pemeriksaan', 'Demam'),
(33, '1345', 2, 102, 7, '2024-05-20', 'Pemeriksaan', 'Demam'),
(34, '1345', 1, 101, 7, '2024-05-21', 'Rawat Inap', 'Flu'),
(35, '1345', 2, 102, 7, '2024-05-29', 'Pemeriksaan', 'Demam'),
(36, '1345', 1, 101, 7, '2024-05-01', 'Rawat Inap', 'Flu'),
(37, '1345', 1, 101, 8, '2024-05-12', 'Rawat Inap', 'Flu'),
(38, '1345', 2, 102, 8, '2024-05-15', 'Pemeriksaan', 'Demam'),
(39, '1345', 2, 102, 9, '2024-05-20', 'Pemeriksaan', 'Demam'),
(40, '1345', 1, 101, 9, '2024-05-21', 'Rawat Inap', 'Flu'),
(41, '1345', 2, 102, 9, '2024-05-29', 'Pemeriksaan', 'Demam');



	-- DELETE FROM pasien; 



	CREATE INDEX idx_tm_nama_tm ON Tenaga_Medis (Nama_TenagaMedis);
	CREATE INDEX idx_tm_spesialisasi ON Tenaga_Medis (Spesialisasi);

	CREATE INDEX idx_rs_kota ON Rumah_Sakit(Kota);
	CREATE INDEX idx_rs_nama_rs ON Rumah_Sakit(Nama_RumahSakit);

	CREATE INDEX idx_ps_nama_ps ON Pasien (Nama_Pasien);
	CREATE INDEX idx_ps_alamat ON Pasien (Alamat);

	CREATE INDEX idx_riwayat_jl ON Riwayat (Jenis_Layanan);

	SELECT * FROM pasien;
	SELECT spesialisasi FROM tenaga_medis;
	SELECT * FROM riwayat;
    
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



SELECT * FROM pasien;
SELECT * FROM riwayat WHERE NIK = 1234;