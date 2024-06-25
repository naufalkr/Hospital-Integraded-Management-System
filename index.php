<?php
require_once 'includes/signup_viewinc.php';
?>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/index.css">
    <title>Index</title>
    <!-- Poppins Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
</head>

<body>
    <div class="container">
        <div class="content-left">
            <img src="Images/wp_login.png" alt="login_image" class="background-image">
        </div>
        <div class="content-right">
            <img src="Images/Logo_MBD_SVG.svg" alt="Logo" class="logo">
            <h1>MEDLINK</h1>
            <p>Welcome! Login to Continue or Register Yourself</p>
            <a href="login.php" style="text-decoration: none;">Login</a>
            <a href="signup.php" style="text-decoration: none;">Register</a>
            <?php
            check_signup_errors();
            ?>
        </div>


    </div>
</body>

</html>