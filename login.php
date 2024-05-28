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
</head>
<body>
    <div class="container">
        <div class="content-left">
            <img src="Images/teaching.png" alt="Gambar Pembelajaran" class="background-image">
        </div>
        <div class="content-right">
            <div class="login-container">
                <div class="header-logo">
                    <img src="Images/logo.png" alt="Logo">
                </div>
                <h1 class = "logo">Aktual Cendekia Course</h1>
                <h1 class = "login">Login</h1>

                <?php if (isset($error)) { ?>
                    <p class="error-message"><?php echo $error; ?></p>
                <?php } ?>

                <form method="POST" action="includes/logininc.php">
                    <label for="username">Username:</label>
                    <input type="text" name="username" id="username" required>

                    <label for="password">Password:</label>
                    <input type="password" name="password" id="password" required>

                    <label for="role">Masuk Sebagai:</label>
                    <input type="text" name="role" id="text" required>


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
