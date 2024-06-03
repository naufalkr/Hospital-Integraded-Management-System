<?php
include_once 'includes/config_sessioninc.php';
include_once 'includes/login_viewinc.php';
include_once 'includes/dbhinc.php'; // Include the database connection file

// Define the NIK to be fetched
$nik = '1234567890';

// Fetch user data based on NIK
$query = $pdo->prepare("SELECT * FROM pasien WHERE NIK = :nik");
$query->execute(['nik' => $nik]);
$user = $query->fetch(PDO::FETCH_ASSOC);

if (!$user) {
  die("User not found.");
}

// Fetch medical reports based on NIK
$query = $pdo->prepare("SELECT * FROM riwayat WHERE NIK = :nik");
$query->execute(['nik' => $nik]);
$reports = $query->fetchAll(PDO::FETCH_ASSOC);


?>


<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>User Dashboard</title>
  <!-- css -->
  <link rel="stylesheet" href="css/userstyle.css" />

  <!-- Tailwind -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!--font awesome-->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Poppins Font -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
</head>


<body>
  <!-- Header -->
  <header class="bg-cyan-950">
    <nav class="mx-auto flex max-w-7xl items-center justify-between p-6 lg:px-8" aria-label="Global">
      <div class="flex lg:flex-1">
        <a href="#" class="-m-1.5 p-1.5">
          <svg xmlns="http://www.w3.org/2000/svg" height="32" width="40" viewBox="0 0 640 512">
            <!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
            <path fill="#63E6BE" d="M192 48c0-26.5 21.5-48 48-48H400c26.5 0 48 21.5 48 48V512H368V432c0-26.5-21.5-48-48-48s-48 21.5-48 48v80H192V48zM48 96H160V512H48c-26.5 0-48-21.5-48-48V320H80c8.8 0 16-7.2 16-16s-7.2-16-16-16H0V224H80c8.8 0 16-7.2 16-16s-7.2-16-16-16H0V144c0-26.5 21.5-48 48-48zm544 0c26.5 0 48 21.5 48 48v48H560c-8.8 0-16 7.2-16 16s7.2 16 16 16h80v64H560c-8.8 0-16 7.2-16 16s7.2 16 16 16h80V464c0 26.5-21.5 48-48 48H480V96H592zM312 64c-8.8 0-16 7.2-16 16v24H272c-8.8 0-16 7.2-16 16v16c0 8.8 7.2 16 16 16h24v24c0 8.8 7.2 16 16 16h16c8.8 0 16-7.2 16-16V152h24c8.8 0 16-7.2 16-16V120c0-8.8-7.2-16-16-16H344V80c0-8.8-7.2-16-16-16H312z" />
          </svg>
        </a>
        <p class="mx-4 py-1 text-white text-xl font-semibold">
          User Dashboard
        </p>
      </div>
      <div class="hidden lg:flex lg:flex-1 lg:justify-end">
        <button class="flex bg-teal-500 text-white px-4 py-2 rounded-lg font-regular">
          Log Out
        </button>
      </div>
    </nav>
  </header>

  <!-- User Profile -->
  <div class="flex">
    <div class="w-1/3 bg-white">
      <div class="flex items-center mb-4 p-10">
        <img src="" alt="Profile Picture" class="bg-teal-500 text-white h-52 w-40 flex items-center justify-center rounded-lg mr-4" />
        <div>
          <!-- Nama Umur -->
          <h2 class="text-2xl font-semibold text-cyan-950"><?php echo htmlspecialchars($user['nama_pasien']); ?></h2>
          <p class="text-gray-500">AGE: <?php echo htmlspecialchars($user['Usia']); ?></p>
        </div>
      </div>
      <!-- Informasi lain -->
      <div class="px-10">
        <h3 class="text-lg font-bold mb-4 text-cyan-950">INFORMATION:</h3>
        <div class="grid grid-cols-1 gap-2">
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">NIK:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['NIK']); ?></span>
            <!-- <span class="text-gray-500"></span> -->
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Gender:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['jenis_kelamin']); ?></span>
            <!-- <span class="text-gray-500"></span> -->
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Address:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['alamat']); ?></span>
            <!-- <span class="text-gray-500"></span> -->
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Blood Type:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['golongan_darah']); ?></span>
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Allergies:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['alergi']); ?></span>
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Height:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['tinggi']); ?></span>
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Weight:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['berat_badan']); ?></span>
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Email:</span>
            <span class="text-gray-500"><?php echo htmlspecialchars($user['email']); ?></span>
            <!-- <span class="text-gray-500"></span> -->
          </div>
          <div class="flex justify-between">
            <span class="font-semibold text-cyan-950 text-sm">Last Check Up:</span>
            <span class="text-gray-500"></span>
          </div>
        </div>
      </div>
    </div>
    <!-- Reports dll -->
    <div class="w-2/3">
      <div class="bg-[#f4f5f8] px-6 py-4 h-screen">
        <div class="flex space-x-4 mb-4">
          <button id="medical-reports-tab" class="bg-teal-500 text-white px-4 py-2 rounded-lg">
            MEDICAL REPORTS
          </button>
          <button id="schedule-tab" class="text-gray-600 px-4 py-2 rounded-lg">
            SCHEDULE
          </button>
        </div>
        <!-- Medical reports -->
        <div id="medical-reports-content" class="tab-content active overflow-y-scroll h-full custom-scrollbar px-2">
          <?php foreach ($reports as $report) : ?>
            <div class="card-container">
              <div class="card">
                <div class="card-minimized">
                  <div class="card-info">
                    <p class="date"><?php echo date('j F Y', strtotime($report['tanggal_riwayat'])); ?></p>
                    <p class="title"><?php echo $report['jenis_layanan']; ?></p>
                  </div>
                  <div class="card-attribute">
                    <div class="pj-info">
                      <?php
                      // Fetch rumah sakit information
                      $query = $pdo->prepare("SELECT * FROM Rumah_Sakit WHERE rumahsakit_id = :id");
                      $query->execute(['id' => $report['rumahsakit_id']]);
                      $rs_info = $query->fetch(PDO::FETCH_ASSOC);
                      ?>
                      <p class="place"><?php echo $rs_info['nama_rumahsakit']; ?></p>
                      <?php
                      // Fetch tenaga medis information
                      $query = $pdo->prepare("SELECT * FROM tenaga_medis WHERE tenagamedis_id = :id");
                      $query->execute(['id' => $report['tenagamedis_id']]);
                      $tm_info = $query->fetch(PDO::FETCH_ASSOC);
                      ?>
                      <p class="dr_name"><?php echo $tm_info['nama_tenagamedis']; ?></p>
                    </div>
                    <span class="status">Berhasil</span>
                    <button class="icon-button" id="open-modal-btn">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" class="icon">
                        <!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
                        <path fill="#083344" d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z" />
                      </svg>
                    </button>

                  </div>
                </div>
              </div>
            </div>
          <?php endforeach; ?>
        </div>
        <!-- Schedule Ini Biarin ae-->
        <div id="schedule-content" class="tab-content">
          <div class="card-container">
            <div class="card">
              <div class="card-minimized">
                <div class="card-info">
                  <p class="date">Apr 07, 2024 at 4:15pm GMT+1</p>
                  <p class="title">Brain Cancer Checkup</p>
                </div>
                <div class="card-attribute">
                  <div class="pj-info">
                    <p class="place">RS Mitra Keluarga Surabaya</p>
                    <p class="dr_name">Dr. John Smith</p>
                  </div>
                  <span class="status">Checkup</span>
                  <button class="icon-button" onclick="toggleDetails(this)">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" class="icon">
                      <!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
                      <path d="M310.6 233.4c12.5 12.5 12.5 32.8 0 45.3l-192 192c-12.5 12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3L242.7 256 73.4 86.6c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0l192 192z" />
                    </svg>
                  </button>
                </div>
              </div>
              <div class="card-details">
                <p>Detail Information</p>
                <div class="payment-info">
                  <div class="payment-item">
                    <p>Apr 1, 2020 19:30 WIB</p>
                    <p>RS Mitra Keluarga Pocan</p>
                    <p>Dr. Anies Baswedan</p>
                    <!-- <span class="status paid">PAID</span> -->
                    <!-- <a href="#" class="view-receipt">View Receipt</a> -->
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Pop Up -->
  <div id="modal-wrapper" class="fixed z-10 inset-0 hidden">
    <div class="flex items-center justify-center min-h-screen bg-gray-600 bg-opacity-75 transition-all">
      <div class="flex flex-col justify-between bg-white rounded-lg w-2/3">
        <button id="close-modal-btn" class="flex justify-end p-6">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" class="icon">
            <!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
            <path fill="#083344" d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c9.4-9.4 24.6-9.4 33.9 0l47 47 47-47c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-47 47 47 47c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-47-47-47 47c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l47-47-47-47c-9.4-9.4-9.4-24.6 0-33.9z" />
          </svg>
        </button>
        <!-- Detail Pop up -->
        <div class="flow-root items-center px-10 mb-10">
          <dl class="-my-3 divide-y divide-gray-100 text-sm">
            <div class="grid grid-cols-1 gap-1 py-3 sm:grid-cols-3 sm:gap-4">
              <dt class="font-medium text-gray-900">Date</dt>
              <dd class="text-gray-700 sm:col-span-2"></dd>
            </div>

            <div class="grid grid-cols-1 gap-1 py-3 sm:grid-cols-3 sm:gap-4">
              <dt class="font-medium text-gray-900">Doctor's Name</dt>
              <dd class="text-gray-700 sm:col-span-2"></dd>
            </div>

            <div class="grid grid-cols-1 gap-1 py-3 sm:grid-cols-3 sm:gap-4">
              <dt class="font-medium text-gray-900">Name of Hospital</dt>
              <dd class="text-gray-700 sm:col-span-2"></dd>
            </div>

            <div class="grid grid-cols-1 gap-1 py-3 sm:grid-cols-3 sm:gap-4">
              <dt class="font-medium text-gray-900">Medicine</dt>
              <dd class="text-gray-700 sm:col-span-2"></dd>
            </div>

            <div class="grid grid-cols-1 gap-1 py-3 sm:grid-cols-3 sm:gap-4">
              <dt class="font-medium text-gray-900">Other details</dt>
              <dd class="text-gray-700 sm:col-span-2"></dd>
            </div>
          </dl>
        </div>
      </div>
    </div>
  </div>

  <!-- JS -->
  <script src="js/user.js"></script>
</body>

</html>

<?php
// Tutup koneksi
// $stmt->close();
// $conn->close();
?>