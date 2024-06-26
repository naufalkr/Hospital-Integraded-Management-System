<?php
include_once 'includes/config_sessioninc.php';
include_once 'includes/login_viewinc.php';
include_once 'includes/dbhinc.php'; // Include the database connection file
// $rumahsakit_id = '502522';
$rumahsakit_id = $_SESSION["rumahsakit_id"];


// Prepare the query to fetch data from rumah_sakit where rumahsakit_id = :rumahsakit_id
$query = $pdo->prepare("SELECT * FROM Rumah_Sakit WHERE rumahsakit_id = :rumahsakit_id");
$query->execute(['rumahsakit_id' => $rumahsakit_id]);
$rumah_sakit = $query->fetch(PDO::FETCH_ASSOC);

if (!$rumah_sakit) {
  die("Not found.");
}

// Prepare the query to fetch data from rumah_sakit where rumahsakit_id = :rumahsakit_id
$dokter = $pdo->prepare("SELECT * FROM tenaga_medis WHERE rumahsakit_id = :rumahsakit_id ORDER BY tenagamedis_id");
$dokter->execute(['rumahsakit_id' => $rumahsakit_id]);
$dokter_rs = $dokter->fetchAll(PDO::FETCH_ASSOC);

if (!$dokter_rs) {
  die("Doctor not found.");
}

$query = "
  SELECT p.*
  FROM (
      SELECT DISTINCT p.NIK
      FROM pasien p
      JOIN riwayat r ON p.NIK = r.NIK
      WHERE r.rumahsakit_id = :rumahsakit_id
  ) AS distinct_nik
  JOIN pasien p ON p.NIK = distinct_nik.NIK
  ORDER BY p.nama_pasien;

    ";

$pasien = $pdo->prepare($query);
$pasien->execute(['rumahsakit_id' => $rumahsakit_id]);
$patients = $pasien->fetchAll(PDO::FETCH_ASSOC);


// $riwayat_dokter = $pdo->prepare("SELECT * FROM tenaga_medis WHERE rumahsakit_id = :rumahsakit_id ORDER BY spesialisasi");
// $riwayat_dokter->execute(['rumahsakit_id' => $rumahsakit_id]);
// $dokter_riwayat = $riwayat_dokter->fetchAll(PDO::FETCH_ASSOC);

//  if (!$dokter_riwayat) {
//  die("Doctor not found.");
//  }
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Document</title>
  <link rel="stylesheet" href="css/rs.css" />
  <!-- Tailwind -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!--font awesome-->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- Poppins Font -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />

  <style>
    .search-bar {
      padding: 0.5rem;
      margin: 1rem 0;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    .doctor-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: 4px;
      padding: 8px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .list-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: 4px;
      padding: 8px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
  </style>
</head>

<body class="bg-gray-200">
  <div class="flex h-screen">
    <!-- Sidebar -->
    <div class="text-xl flex flex-col justify-between w-64 bg-cyan-950 text-center">
      <ul>
        <div class="justify-between">
          <li>
            <a href="#" id="medicalStaffLink" class="block text-white py-4" onclick="showTenagaMedis()">MEDICAL STAFF</a>
          </li>
          <li>
            <a href="#" id="pasienLink" class="block text-white py-4" onclick="showPasien()">PATIENTS</a>
          </li>
          <li>
            <a href="#" id="createReportLink" class="block text-white py-4">CREATE REPORT</a>
          </li>
        </div>
      </ul>
      <form action="includes/logoutinc.php">
        <button class="rounded px-4 py-2 bg-red-500 text-white right-6 mb-4">
          <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </button>
      </form>
    </div>
    <div class="flex-1 p-10 text-2xl font-bold">
      <div id="content" class="flex flex-col">
        <div class="h-[90vh] flex flex-col items-center justify-center ">
          <div class="flex flex-col text-teal-500">
            <h1 class=" justify-start text-6xl mb-2">Welcome To! </h1>
            <h1 class=" justify-start text-7xl"><?php echo htmlspecialchars($rumah_sakit['nama_rumahsakit']); ?></h1>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>
    let originalContent;


    window.onload = function() {
      originalContent = document.getElementById("content").innerHTML;
    };

    const tenagaMedis = `
        <div class="flex flex-row justify-between">
            <button class=" text-cyan-950 mr-4 p-2" onclick="switchContent()">
              <i class="fa-solid fa-chevron-left"></i>
            </button>
            <div class="space-x-4">
              <a href="signup_tenagamedis.php" class="py-1 px-4 text-m font-regular rounded-full bg-teal-500 text-white">Add</a>
              <input type="text" id="searchBar" onkeyup="filterDoctors()" placeholder="Search for doctors.." class="search-bar py-1 rounded-full bg-white text-gray-900 outline-none pl-6" />
            </div>
        </div>
        <div class="h-[80vh] overflow-y-scroll custom-scrollbar rounded-lg">
          <ul id="doctorList">
            <?php foreach ($dokter_rs as $doks) : ?>
              <li class="doctor-item bg-white">
                <div class="flex items-center ">
                  <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                  <div>
                    <p class="text-sm doctor-name"><?php echo htmlspecialchars($doks['nama_tenagamedis']); ?> - <?php echo htmlspecialchars($doks['tenagamedis_id']); ?></p>
                    <p class="text-xs text-gray-400"><?php echo htmlspecialchars($doks['spesialisasi']); ?></p>
                  </div>
                </div>
                <div>
                  <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('MEDICAL STAFF View', '<?php echo $doks['tenagamedis_id']; ?>', '<?php echo htmlspecialchars($doks['nama_tenagamedis']); ?>')">View</button>
                </div>
              </li>
            <?php endforeach; ?>
          </ul>
        </div>
        <div class="flex justify-center my-4">
         
        </div>
          
      `;

    function filterDoctors() {
      const searchValue = document.getElementById("searchBar").value.toLowerCase();
      const doctorItems = document.querySelectorAll(".doctor-item");
      doctorItems.forEach(item => {
        const name = item.querySelector(".doctor-name").textContent.toLowerCase();
        if (name.includes(searchValue)) {
          item.style.display = "";
        } else {
          item.style.display = "none";
        }
      });
    }


    const pasien = `
         <div class="flex flex-row justify-between">
            <button class=" text-cyan-950 mr-4 p-2" onclick="switchContent()">
              <i class="fa-solid fa-chevron-left"></i>
            </button>
            <div class="space-x-4">
              <input type="text" id="searchBarPasien" onkeyup="filterPatients()" placeholder="Search for patients.." class="search-bar py-1 rounded-full bg-white text-gray-900 outline-none pl-6" />
            </div>
        </div>
        <div class="h-[80vh] overflow-y-scroll custom-scrollbar rounded-lg">
          <ul id="patientList">
            <?php foreach ($patients as $patient) : ?>
              <li class="list-item bg-white">
                <div class="flex items-center justify-between">
                  <div class="flex flex-row items-center">
                    <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                  <div class="items-center">
                    <p class="text-sm patient-name"><?php echo htmlspecialchars($patient['nama_pasien']); ?></p>
                    <p class="text-xs text-gray-400"><?php echo htmlspecialchars($patient['NIK']); ?></p>
                  </div>
                  </div>
                  <div>
                    <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-2" onclick="switchContent('Pasien View', '<?php echo $patient['NIK']; ?>', '<?php echo htmlspecialchars($patient['nama_pasien']); ?>')">View</button>
                  </div>
                </div>
              </li>
            <?php endforeach; ?>
          </ul>
        </div>
      `;

    function filterPatients() {
      const searchValue = document.getElementById("searchBar").value.toLowerCase();
      const doctorItems = document.querySelectorAll(".list-item");
      doctorItems.forEach(item => {
        const name = item.querySelector(".patient-name").textContent.toLowerCase();
        if (name.includes(searchValue)) {
          item.style.display = "";
        } else {
          item.style.display = "none";
        }
      });
    }

    function filterPatients() {
      const searchValue = document.getElementById("searchBarPasien").value.toLowerCase();
      const patientItems = document.querySelectorAll(".list-item");
      patientItems.forEach(item => {
        const name = item.querySelector(".patient-name").textContent.toLowerCase();
        if (name.includes(searchValue)) {
          item.style.display = "";
        } else {
          item.style.display = "none";
        }
      });
    }

    const tambahRiwayat = `
        <button class=" text-cyan-950 mr-4 p-2" onclick="switchContent()">
              <i class="fa-solid fa-chevron-left"></i>
            </button>
        <div class="flex flex-col items-center justify-center h-[90vh]">
        <h1 class="flex justify-center my-4 text-2xl text-gray-600">CREATE REPORT</h1>
         

           <form class="space-y-6 p-12 bg-white rounded-lg shadow-md text-gray" action="riwayatinc.php" method="post">

            <div class="flex justify-between items-center">
                <label for="nik" class="w-1/3">NIK:</label>
                <input type="text" id="nik" name="NIK" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
            </div>
            <div class="flex justify-between items-center">
                <label for="dokter" class="w-1/3">ID Dokter:</label>
                <input type="text" id="dokter" name="tenagamedis_id" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
            </div>
            <div class="flex justify-between items-center">
                <label for="waktu" class="w-1/3">Tanggal:</label>
                <input type="date" id="waktu" name="tanggal_riwayat" class="w-2/3 rounded-lg shadow-md bg-gray-100">
            </div>
            <div class="flex justify-between items-center">
                <label for="obat" class="w-1/3">ID Obat:</label>
                <input type="text" id="obat" name="obat_id" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
            </div>
            <div class="flex justify-between items-center">
                <label for="jenisLayanan" class="w-1/3">Jenis Layanan:</label>
                <input type="text" id="jenisLayanan" name="jenis_layanan" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
            </div>
            <div class="flex justify-between items-center">
                <label for="keterangan" class="w-1/3">Keterangan:</label>
                <input type="text" id="keterangan" name="keterangan_penyakit" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
            </div>
            <input type="hidden" name="rumahsakit_id" value="<?php echo $rumahsakit_id; ?>">
            <input type="submit" value="Submit" class="flex my-4 mx-auto p-2 rounded-lg bg-gray-400 text-white cursor-pointer hover:bg-teal-500" >
            </form>
        </div>
        `;

    function switchContent(contentType, id = null, nama = null) {
      switch (contentType) {
        case "MEDICAL STAFF":
          content.innerHTML = tenagaMedis;
          setActiveLink('medicalStaffLink');
          break;
        case "MEDICAL STAFF View":
          // Fetch patient list for the selected doctor
          // content.innerHTML = tenagaMedisView;
          fetchPatients(id, nama);
          break;
        case "PATIENTS":
          content.innerHTML = pasien;
          setActiveLink('pasienLink');
          break;
        case "Pasien View":
          // content.innerHTML = pasienView;
          fetchPatientsView(id, nama);
          break;
        case "Detail Riwayat":
          // content.innerHTML = detailRiwayat;
          fetchPatientViewFull(id, nama);
          break;
        case "CREATE REPORT":
          content.innerHTML = tambahRiwayat;
          setActiveLink('createReportLink');
          break;
        default:
          content.innerHTML = originalContent;
          setActiveLink('');
      }
    }

    async function fetchPatients(tenagamedisId, namaTenagaMedis) {
      try {
        const response = await fetch(`fetch_patients.php?tenagamedis_id=${tenagamedisId}`);
        const responseData = await response.text(); // Mengambil data teks dari respons

        // Cek apakah respons valid JSON
        try {
          const patients = JSON.parse(responseData);
          showPatientList(patients, namaTenagaMedis);
        } catch (error) {
          console.error('Error parsing JSON:', error);
          throw new Error('Invalid JSON response from server');
        }
      } catch (error) {
        console.error('Error fetching patient data:', error.message);
      }
    }




    function showPatientList(patients, namaTenagaMedis) {
      // Construct HTML for patient list
      let patientListHTML = `
                <div class="flex flex-row justify-between">
                <button class=" text-cyan-950" onclick="switchContent('MEDICAL STAFF')">
                <i class="fa-solid fa-chevron-left"></i>
                </button>
                <h1 class="text-black">Riwayat Pasien ${namaTenagaMedis}</h1>
                </div>
                <div class="h-[90vh] overflow-y-scroll custom-scrollbar rounded-lg my-auto">
                    <ul>
            `;
      patients.forEach(patient => {
        patientListHTML += `
                    <li class="flex items-center justify-between shadow-md m-4 rounded-lg bg-white">
                        <div class="flex flex-row">
                            <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                            <div class="flex items-center justify-center flex-col">
                                <p class="text-sm">${patient.nama_pasien}</p>
                                <p class="text-xs text-gray-400">NIK: ${patient.NIK}</p>
                            </div>
                        </div>
                        <div>
                            <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Pasien View', '${patient.NIK}', '${patient.nama_pasien}')">Detail</button>
                        </div>
                    </li>
                `;
      });
      patientListHTML += `
                    </ul>
                </div>
            `;
      content.innerHTML = patientListHTML;
    }

    async function fetchPatientsView(NIK, namaPasien) {
      try {
        const response = await fetch(`fetch_patientsview.php?NIK=${NIK}`);
        const responseData = await response.text(); // Mengambil data teks dari respons

        // Cek apakah respons valid JSON
        try {
          const patient = JSON.parse(responseData);
          viewPatientDetails(patient, namaPasien);
        } catch (error) {
          console.error('Error parsing JSON:', error);
          throw new Error('Invalid JSON response from server');
        }
      } catch (error) {
        console.error('Error fetching patient data:', error.message);
      }
    }

    function viewPatientDetails(patients, namaPasien) {
      // Implement function to view detailed patient information
      // Example: Redirect to another page or load detailed information in the current view
      let patientListHTML = `
                <div class="flex flex-row justify-between">
                <button class="text-cyan-950" onclick="switchContent()">
                <i class="fa-solid fa-chevron-left"></i>
                </button>
                <h1 class="text-black">Riwayat  - ${namaPasien}</h1>
                </div>
                <div class="h-[90vh] overflow-y-scroll custom-scrollbar rounded-lg my-auto">
                    <ul>
            `;
      patients.forEach(patient => {
        patientListHTML += `
                    <li class="flex items-center justify-between shadow-md m-4 rounded-lg bg-white">
                        <div class="flex flex-row">
                            <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                            <div class="flex items-center justify-center flex-col">
                                <p class="text-sm">${patient.jenis_layanan} - ${patient.keterangan_penyakit}</p>
                                <p class="text-xs text-gray-400">Tanggal: ${patient.tanggal_riwayat}</p>
                            </div>
                        </div>
                        <div>
                            <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Detail Riwayat', '${patient.riwayat_id}', '${patient.jenis_layanan}')">Detail</button>
                        </div>
                    </li>
                `;
      });
      patientListHTML += `
                    </ul>
                </div>
            `;
      content.innerHTML = patientListHTML;
    }
    // async function fetchPatientViewFull(NIK, namaPasien) {
    //   console.log(NIK);
    //   console.log(namaPasien);
      
    //   try {
    //     const response = await fetch(`fetch_patientsviewfull.php?NIK=${NIK}`);
    //     const responseData = await response.text(); // Mengambil data teks dari respons

    //     // Cek apakah respons valid JSON
    //     try {
    //       const patient = JSON.parse(responseData);
    //       viewPatientDetailFull(patient, namaPasien);
    //     } catch (error) {
    //       console.error('Error parsing JSON:', error);
    //       throw new Error('Invalid JSON response from server');
    //     }
    //   } catch (error) {
    //     console.error('Error fetching patient data:', error.message);
    //   }
    // }

    async function fetchPatientViewFull(riwayat_id, keterangan) {
      console.log(riwayat_id);
      console.log(keterangan);
      try {
        const response = await fetch(`fetch_patientsviewfull.php?riwayat_id=${riwayat_id}`);
        const responseData = await response.text(); // Mengambil data teks dari respons

        // Cek apakah respons valid JSON
        try {
          const patient = JSON.parse(responseData);
          viewPatientDetailFull(patient, keterangan);
        } catch (error) {
          console.error('Error parsing JSON:', error);
          throw new Error('Invalid JSON response from server');
        }
      } catch (error) {
        console.error('Error fetching patient data:', error.message);
      }
    }

    // async function fetchPatientViewFull(NIK, keterangan) {
      // console.log(NIK);
    //   try {
    //     const response = await fetch(`fetch_patientsviewfull.php?NIK=${NIK}`);
    //     const responseData = await response.text(); // Mengambil data teks dari respons

    //     // Cek apakah respons valid JSON
    //     try {
    //       const patient = JSON.parse(responseData);
    //       viewPatientDetailFull(patient, keterangan);
    //     } catch (error) {
    //       console.error('Error parsing JSON:', error);
    //       throw new Error('Invalid JSON response from server');
    //     }
    //   } catch (error) {
    //     console.error('Error fetching patient data:', error.message);
    //   }
    // }



    function viewPatientDetailFull(patients, keterangan) {
      // Ambil hanya satu pasien pertama dari array patients
      const patient = patients[0];

      let patientDetailHTML = `
            <div class="flex flex-row gap-4">
            <button class=" text-cyan-950 " onclick="switchContent()">
            <i class="fa-solid fa-chevron-left"></i>
            </button>
            <p class="text-black">${keterangan}</p>
            </div>
            <div class="h-[90vh] overflow-y-scroll custom-scrollbar rounded-lg my-auto">
                <div class="flex flex-col items-center justify-center h-[90vh]">
                    
                    <h1 class="flex justify-center my-4 text-2xl text-gray-600">Detail Riwayat</h1>
                    <form class="space-y-6 p-12 bg-white rounded-lg shadow-md text-gray-600 w-[30%]">
                        <div class="flex flex-row justify-between items-center">
                            <p for="NIK">NIK:</p>
                            <p id="NIK">${patient.NIK}</p>
                        </div>
                        <div class="flex flex-row justify-between items-center">
                            <p for="dokter">Dokter:</p>
                            <p id="dokter">${patient.tenagamedis_id}</p>
                        </div>
                        <div class="flex flex-row justify-between items-center">
                            <p for="waktu">Waktu:</p>
                            <p id="waktu">${patient.tanggal_riwayat}</p>
                        </div>
                        <div class="flex flex-row justify-between items-center">
                            <p for="jenisLayanan">Jenis Layanan:</p>
                            <p id="jenisLayanan">${patient.jenis_layanan}</p>
                        </div>
                          <div class="flex flex-row justify-between items-center">
                            <p for="jenisLayanan">ID Obat:</p>
                            <p id="jenisLayanan">${patient.obat_id}</p>
                        </div>
                        <div class="flex flex-row justify-between items-center">
                            <p for="penyakit">Keterangan:</p>
                            <p>${patient.keterangan_penyakit}</p>
                        </div>
                    </form>
                </div>
            </div>
        `;

      content.innerHTML = patientDetailHTML;
    }
    function togglePopup() {
      document.getElementById("popup").classList.toggle("active");
    }

    document.querySelectorAll("ul li a").forEach((link) => {
      link.addEventListener("click", (e) => {
        e.preventDefault();
        switchContent(e.target.innerText);
      });
    });

    function setActiveLink(activeLinkId) {
      // Get all the links
      const links = document.querySelectorAll('ul li a');

      // Remove active class from all links
      links.forEach(link => {
        link.classList.remove('bg-[#041b23]', 'text-teal-500');
        link.classList.add('text-white');
      });

      // Add active class to the clicked link
      const activeLink = document.getElementById(activeLinkId);
      activeLink.classList.remove('text-white');
      activeLink.classList.add('bg-[#041b23]', 'text-teal-500');
    }
  </script>
</body>

</html>