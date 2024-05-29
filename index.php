<?php
    require_once 'includes/signup_viewinc.php';
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <title>Index</title>
</head>
<body>
    <div class="container">
        <div class="content-left">
            <img src="Images/teaching.png" alt="Gambar Pembelajaran" class="background-image">
        </div>
        <div class="content-right">
            <img src="Images/logo.jpg" alt="Logo Perusahaan" class="logo">
            <h1>Aktual Cendekia Course</h1>
            <p>Mulai perjalanan belajar Anda bersama kami. Pilih opsi untuk memulai:</p>
            <a href="login.php">Masuk</a>
            <a href="signup.php">Daftar</a>
            <?php
                check_signup_errors();
                ?>
        </div>

        
    </div>
</body>
</html>
