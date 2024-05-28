<?php
    include_once 'includes/config_sessioninc.php';
    include_once 'includes/login_viewinc.php';
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Raleway:300,300i,400,400i,600,600i,700,700i" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
    <script src="js/dashboard.js" defer></script>
 


</head>

<body>
    <center>
    <header id="header" class="fixed-top d-flex align-items-center">
    <div class="container d-flex align-items-center justify-content-between">

        <div class="logo">
            <a href="index.html" class="logo-link">
            <img src="Images/logo.png" alt="" class="logo-image">
            <h1 class="logo-text">Aktual Cendekia Course</h1>
            </a>
        </div>

        <nav id="navbar" class="navbar">
            <ul>
                <li><a class="nav-link scrollto active" href="#course">Course</a></li>
                <li><a class="nav-link scrollto" href="#jadwal">Jadwal</a></li>
                <li><a class="nav-link scrollto" href="#pesan">Pesan</a></li>
                <li><a class="nav-link scrollto" href="siswaterdaftar.php">Siswa Terdaftar</a></li>
                <?php output_username()?>
                
            </ul>
        </nav>
        </div>
    </header>

    <form action=""></form>
    <!-- ======= Courses ======= -->
    <section id="course" class="course section-bg">
        <div class="container" >

            <div class="course-title">
                <p>Course Tersedia</p>
            </div>

            <div class="row">
                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <img src="Images/alin.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/LinearAlgebra.php">Linear Algebra</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 15th</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <div class="icon"><i class="bx bx-file"></i></div>
                        <img src="Images/matdis.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/DiscreteMath.php">Discrete Math</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 17th</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <div class="icon"><i class="bx bx-tachometer"></i></div>
                        <img src="Images/basicpro.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/BasicProgramming.php">Basic Programming</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 18th</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <div class="icon"><i class="bx bx-world"></i></div>
                        <img src="Images/oop.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/ObjectOrientedProgramming.php">Object Oriented Programming</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 20th</p>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <img src="Images/ai.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/AI.php">Artificial Intelligence</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 21st</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <div class="icon"><i class="bx bx-file"></i></div>
                        <img src="Images/sisdig.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/DigitalSystem.php">Digital System</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 23th</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <div class="icon"><i class="bx bx-tachometer"></i></div>
                        <img src="Images/strukdat.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/DataStructures.php">Data Structures</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 25th</p>                    </div>
                </div>

                <div class="col-md-6 col-lg-3 d-flex align-items-stretch">
                    <div class="icon-box">
                        <div class="icon"><i class="bx bx-world"></i></div>
                        <img src="Images/mbd.png" alt="" class="icon-image">
                        <h4 class="title"><a href="Material/MBD.php">Database Management</a></h4>
                        <p class="description">Next online class schedule:</p>
                        <p class="tanggal">December 26th</p>                    </div>
                </div>

            </div>

        </div>
    </section>

    <!-- ======= jadwal  ======= -->
    <section id="jadwal" class="jadwal">
        <div class="container">
            <div class="jadwal-title">
                <p>Jadwal Kelas Online</p>
            </div>                
        </div>
                <!-- JADWAL KEGIATAN DI SINI -->
        </div>
        <div class="wrapper">
            <header>
                <p class="current-date"></p>
                <div class="icons">
                    <span id="prev" class="material-symbols-rounded">chevron_left</span>
                    <span id="next" class="material-symbols-rounded">chevron_right</span>
                </div>
            </header>
            <div class="calendar">
                <ul class="weeks">
                    <li>Sun</li>
                    <li>Mon</li>
                    <li>Tue</li>
                    <li>Wed</li>
                    <li>Thu</li>
                    <li>Fri</li>
                    <li>Sat</li>
                </ul>
                <ul class="days"></ul>
            </div>
        </div>
    </section>


    <section>
    <!-- ======= pesan ======= -->
    <section id="pesan" class="pesan-form">
        <h3>Kirim Pesan</h3>
        <p>Kirim pesan ke sesama siswa atau guru.</p>
        <form action="includes/pesaninc.php" method="post" id="pesan-form">
            <div class="person">
                <label for="pengirim"  >Pengirim:</label>
                <input type="text" name="pengirim">
                <label for="penerima" >Penerima:</label>
                <input type="text" name= "penerima">
            </div>
            <div class="pesan">
                <label for="pesan" >Pesan:</label>
                <input type="text" name="pesan">
            </div>
            <button type="submit">Kirim</button>
        </form>
    </section>

        <!-- <nav>
            <ul>
                <li><a href="Material/LinearAlgebra.php">Linear Algebra</a></li>
                <li><a href="Material/DiscreteMath.php">Discrete Math</a></li>
                <li><a href="Material/BasicProgramming.php">Basic Programming</a></li>
                <li><a href="Material/DigitalSystem.php">Digital System</a></li>
                <li><a href="Material/DataStructures.php">Data Structures</a></li>
                <li><a href="Material/ObjectOrientedProgramming.php">Object Oriented Programming</a></li>
            </ul>
        </nav> -->

        <footer>
            <p>&copy; 2023 Aktual Cendekia Course Website. All rights reserved.</p>
        </footer>
    </center>

</body>

</html>
