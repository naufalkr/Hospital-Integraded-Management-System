<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Table</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Raleway:300,300i,400,400i,600,600i,700,700i" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/course.css"/>

    <style>
        body {
            background-color: #f0f8ff; /* Warna latar belakang biru muda */
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        table {
            width: 80%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #0074cc; /* Warna latar belakang header biru tua */
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2; /* Warna latar belakang baris ganjil */
        }

        tr:hover {
            background-color: #cce5ff; /* Warna latar belakang saat dihover biru terang */
        }
    </style>
</head>

<body>

<header id="header" class="fixed-top d-flex align-items-center">
        <div class="container d-flex align-items-center justify-content-between">

            <div class="logo">
                <a href="index.html" class="logo-link">
                    <img src="Images/logo.png" alt="" class="logo-image">
                    <h1 class="logo-text">Daftar Siswa</h1>
                </a>
            </div>

            <nav id="navbar" class="navbar">
                <ul>
                    <li><a class="nav-link scrollto active" href="dashboard.php">Course</a></li>
                    <li><a class="nav-link scrollto" href="#jadwal">Jadwal</a></li>

                </ul>
            </nav>
        </div>
    </header>
    <?php
    include 'includes/dbhinc.php';

    try {
        $stmt = $pdo->query("SELECT * FROM users");
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (count($users) > 0) {
            echo "<table>";
            echo "<tr><th>ID</th><th>Username</th><th>Email</th></tr>";
            foreach ($users as $user) {
                if($user['usertype'] == 'guru'){
                    continue;
                }
                echo "<tr>";
                echo "<td>{$user['id']}</td>";
                echo "<td>{$user['username']}</td>";
                echo "<td>{$user['email']}</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "No users found.";
        }
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
    ?>
</body>
</html>
