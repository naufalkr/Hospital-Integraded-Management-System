<?php
require_once 'includes/config_sessioninc.php';
require_once 'includes/signup_viewinc.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign-Up</title>
    <link rel="stylesheet" href="css/signup.css">
</head>
<body>
    <div class="container">
        <div class="content-left">
            <img src="Images/teaching.png" alt="Gambar Pembelajaran" class="background-image">
        </div>
        <div class="content-right">
            <div class="signup-container">
                <div class="header-logo">
                    <img src="Images/logo.png" alt="Logo">
                </div>
                <h1 class="logo">Aktual Cendekia Course</h1>
                <h1 class="signup">Sign-Up</h1>

                <form action="includes/signupinc.php" method="post">
                    <input type="text" name="NIK" placeholder="NIK" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <input type="text" name="email" placeholder="E-mail" required>
                    <input type="text" name="nama_pasien" placeholder="Nama" required>
                    <input type="date" name="Tanggal_Lahir" placeholder="Tanggal Lahir" required>
                    <input type="text" name="alamat" placeholder="Alamat" required>
                    <input type="number" name="tinggi" placeholder="Tinggi (cm)" required>
                    <input type="number" name="berat_badan" placeholder="Berat Badan (kg)" required>
                    <input type="text" name="golongan_darah" placeholder="Golongan Darah" required>
                    <input type="text" name="alergi" placeholder="Alergi" required>
                    <input type="text" name="no_telepon_pasien" placeholder="Nomor Telepon" required>
                    <input type="text" name="jenis_kelamin" placeholder="Jenis Kelamin" required>

                    <button>Sign-up</button>
                </form>

                <?php
                check_signup_errors();
                ?>
            </div>
        </div>
    </div>
</body>
</html>
