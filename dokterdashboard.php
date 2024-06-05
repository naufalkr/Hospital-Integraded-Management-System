<?php
include_once 'includes/config_sessioninc.php';
include_once 'includes/login_viewinc.php';
include_once 'includes/dbhinc.php'; // Include the database connection file

// Define the tenagamedis_id to be fetched
$tenagamedis_id = '101';

// Fetch user data based on tenagamedis_id
$query = $pdo->prepare("SELECT * FROM tenaga_medis WHERE tenagamedis_id = :tenagamedis_id");
$query->execute(['tenagamedis_id' => $tenagamedis_id]);
$dokter = $query->fetch(PDO::FETCH_ASSOC);

if (!$dokter) {
  die("User not found.");
}

// // Fetch medical reports based on tenagamedis_id
// $query = $pdo->prepare("SELECT * FROM Rumah_Sakit WHERE tenagamedis_id = :tenagamedis_id");
// $query->execute(['tenagamedis_id' => $tenagamedis_id]);
// $reports = $query->fetchAll(PDO::FETCH_ASSOC);

// Fetch medical reports based on tenagamedis_id
$query = $pdo->prepare("SELECT * FROM riwayat WHERE tenagamedis_id = :tenagamedis_id");
$query->execute(['tenagamedis_id' => $tenagamedis_id]);
$reports = $query->fetchAll(PDO::FETCH_ASSOC);

// // Ambil id dari parameter URL
// $reportId = $_GET['id'];

// // Query untuk mengambil informasi riwayat dari database berdasarkan id
// $query = $pdo->prepare("SELECT riwayat.tanggal_riwayat, tenaga_medis.nama_tenagamedis, rumah_sakit.nama_rumahsakit 
//                         FROM riwayat 
//                         INNER JOIN tenaga_medis ON riwayat.tenagamedis_id = tenaga_medis.tenagamedis_id 
//                         INNER JOIN rumah_sakit ON riwayat.rumahsakit_id = rumah_sakit.rumahsakit_id 
//                         WHERE riwayat.riwayat_id = :id");
// $query->execute(['id' => $reportId]);
// $reportInfo = $query->fetch(PDO::FETCH_ASSOC);

// // Kembalikan data dalam format JSON
// echo json_encode($reportInfo);


?>



<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Medical Report Dashboard</title>
    <!-- css -->
    <link rel="stylesheet" href="dokter/style.css" />

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!--font awesome-->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
      integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />

    <!-- Poppins Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
      rel="stylesheet"
    />
  </head>
  <body class="bg-[#f4f5f8]">
    <!-- Header -->
    <div class="gradient-bg p-8 flex justify-between items-center text-white">
      <div class="flex items-center">
        <div>
          <img
            src="https://via.placeholder.com/100"
            alt="Profile Picture"
            class="rounded-full text-white h-20 w-20 flex items-center justify-center mr-4"
          />
        </div>
        <div class="dokter-info">
          <!-- <h1 class="text-2xl font-bold">Dr. Rook Rookie, Ph.D</h1> -->
          <span class="text-2xl font-bold"><?php echo htmlspecialchars($dokter['nama_tenagamedis']); ?></span>
          <p class="text-sm">
            <?php echo htmlspecialchars($dokter['spesialisasi']); ?> <span>at</span> Mitra Keluarga Surabaya
          </p>
        </div>
      </div>
      <div class="flex items-center">
        <input
          type="text"
          placeholder="Search patient's ID"
          class="py-2 rounded-l-full bg-white text-gray-900 outline-none pl-6"
        />
        <button class="p-2 bg-white rounded-r-full text-white">
          <i class="fas fa-search fa-lg" style="color: #63e6be"></i>
        </button>
        <button class="ml-4 p-3 bg-gray-800 rounded-full text-white text-sm">
          Logout
        </button>
      </div>
    </div>

    <!-- Patient Information -->
    <div
      class="container mx-auto mt-6 grid grid-cols-1 lg:grid-cols-3 gap-6 px-6"
    >
      <div class="bg-white rounded-lg p-6">
        <h3 class="text-xl font-bold mb-4 text-teal-500">
          PATIENT INFORMATION
        </h3>
        <div class="text-cyan-950">
          <div class="mb-4">
            <h2 class="text-2xl font-semibold text-cyan-950">asda</h2>
            <p class="text-sm text-gray-500">AGE: 32</p>
          </div>
          <div class="grid grid-cols-2 gap-2">
            <div class="font-semibold">NIK:</div>
            <div class="text-gray-500">1234567891112</div>
            <div class="font-semibold">Gender:</div>
            <div class="text-gray-500">Male</div>
            <div class="font-semibold">Address:</div>
            <div class="text-gray-500">Jl. Keputih Tegal Timur No.8</div>
            <div class="font-semibold">Blood Type:</div>
            <div class="text-gray-500">O+</div>
            <div class="font-semibold">Allergies:</div>
            <div class="text-gray-500">Peanuts</div>
            <div class="font-semibold">Height:</div>
            <div class="text-gray-500">173 cm</div>
            <div class="font-semibold">Weight:</div>
            <div class="text-gray-500">90 kg</div>
            <div class="font-semibold">Email:</div>
            <div class="text-gray-500">john@example.com</div>
            <div class="font-semibold">Last Check Up:</div>
            <div class="text-gray-500">20 May 2024</div>
          </div>
        </div>
      </div>

      <!-- Patient Medical Reports -->
      <div class="bg-white rounded-lg p-4 col-span-2">
        <h3 class="text-xl mb-4 font-bold p-2 text-teal-500">
          PATIENT MEDICAL REPORTS
        </h3>
        <div class="overflow-y-scroll h-96 custom-scrollbar px-2">
          <div class="card-container">
            <div class="card">
              <div class="card-minimized">
                <div class="card-info">
                  <p class="date">213131</p>
                  <p class="title">asdada</p>
                </div>
                <div class="card-attribute">
                  <div class="pj-info">
                    <p class="place">hdgerre</p>
                    <p class="dr_name">wrwefw4w</p>
                  </div>
                  <span class="status">qeqeq</span>
                  <button class="icon-button" id="open-modal-btn">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 512 512"
                      class="icon"
                    >
                      <!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
                      <path
                        fill="#083344"
                        d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z"
                      />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pop Up -->
    <div id="modal-wrapper" class="fixed z-10 inset-0 hidden">
      <div
        class="flex items-center justify-center min-h-screen bg-gray-600 bg-opacity-75 transition-all"
      >
        <div class="flex flex-col justify-between bg-white rounded-lg w-2/3">
          <button id="close-modal-btn" class="flex justify-end p-6">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              class="icon"
            >
              <!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
              <path
                fill="#083344"
                d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM175 175c9.4-9.4 24.6-9.4 33.9 0l47 47 47-47c9.4-9.4 24.6-9.4 33.9 0s9.4 24.6 0 33.9l-47 47 47 47c9.4 9.4 9.4 24.6 0 33.9s-24.6 9.4-33.9 0l-47-47-47 47c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l47-47-47-47c-9.4-9.4-9.4-24.6 0-33.9z"
              />
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
    <script src="dokter/index.js"></script>
  </body>
</html>
