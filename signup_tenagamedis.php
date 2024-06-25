<?php
require_once 'includes/config_sessioninc.php';
require_once 'includes/signup_viewinc.php';

// Fetch the `rumahsakit_id` from the session
if(isset($_SESSION["rumahsakit_id"])) {
    $rumahsakit_id = $_SESSION["rumahsakit_id"];
} else {
    // Handle the case where the session variable is not set
    // This could be an error message or a redirection to another page
    echo "Error: Rumah Sakit ID not set in session.";
    exit;
}
?>

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign-Up</title>
    <link rel="stylesheet" href="css/register.css">
</head>
<body>
    <div class="container">
        <div class="content-left">
            <img src="Images/wp_login.png" alt="Gambar Pembelajaran" class="background-image">
        </div>
        <div class="content-right">
            <div class="header-logo">
                    <img src="Images/Logo_MBD.png" alt="Logo">
                    <h1 >MEDLINK</h1>
                </div>
                <h1 class="register-header">REGISTER</h1>
                <form action="includes/signupinc.php" method="post" class="form-container">
                    <input type="text" name="tenagamedis_id" placeholder="ID" required>
                    <input type="hidden" name="rumahsakit_id" value="<?php echo htmlspecialchars($rumahsakit_id); ?>" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <input type="text" name="email" placeholder="E-mail" required>
                    <input type="text" name="nama_tenagamedis" placeholder="Nama" required>
                    <input type="text" name="spesialisasi" placeholder="Spesialisasi" required>
                    <input type="text" name="jenis_kelamin" placeholder="Jenis Kelamin" required>
                    <input type="text" name="no_telepon_tenagamedis" placeholder="Nomor Telepon" required>
                    <button>Sign-up</button>
                </form>

                <?php
                check_signup_errors();
                ?>
        </div>
    </div>
</body>
</html>
