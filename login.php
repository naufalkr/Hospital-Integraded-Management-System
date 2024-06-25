<?php
require_once "includes/config_sessioninc.php";
require_once "includes/login_viewinc.php";
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="css/login.css">

    <!--font awesome-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- Poppins Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
</head>

<body>
    <div class="container">
        <div class="content-left">
            <img src="Images/wp_login.png" alt="Gambar Pembelajaran" class="background-image">
        </div>
        <div class="content-right">
            <div class="login-container">
                <div class="header-logo">
                    <img src="Images/Logo_MBD.png" alt="Logo">
                    <h1 class="logo">MEDLINK</h1>
                </div>
                <h1 class="login">LOGIN</h1>

                <?php if (isset($error)) { ?>
                    <p class="error-message"><?php echo $error; ?></p>
                <?php } ?>

                <form method="POST" action="includes/logininc.php">
                    <label for="NIK">NIK:</label>
                    <input type="text" name="NIK" id="NIK" required>

                    <label for="password">Password:</label>
                    <input type="password" name="password" id="password" required>

                    <label for="role">Masuk Sebagai:</label>
                    <select name="role" id="role" required>
                        <option value="tenaga_medis">Tenaga Medis</option>
                        <option value="pasien">Pasien</option>
                        <option value="rumah_sakit">Rumah Sakit</option>
                    </select>


                    <input type="submit" value="Login">
                </form>

                <?php
                check_login_errors();
                ?>
            </div>
        </div>
    </div>
</body>

</html>