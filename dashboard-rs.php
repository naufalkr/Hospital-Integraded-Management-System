<?php
    include_once 'includes/config_sessioninc.php';
    include_once 'includes/login_viewinc.php';
    include_once 'includes/dbhinc.php'; // Include the database connection file
    $rumahsakit_id = '502522';

    // Prepare the query to fetch data from rumah_sakit where rumahsakit_id = :rumahsakit_id
    $query = $pdo->prepare("SELECT * FROM Rumah_Sakit WHERE rumahsakit_id = :rumahsakit_id");
    $query->execute(['rumahsakit_id' => $rumahsakit_id]);
    $rumah_sakit = $query->fetch(PDO::FETCH_ASSOC);

    if (!$rumah_sakit) {
    die("Not found.");
    }

    // Prepare the query to fetch data from rumah_sakit where rumahsakit_id = :rumahsakit_id
    $dokter = $pdo->prepare("SELECT * FROM tenaga_medis WHERE rumahsakit_id = :rumahsakit_id ORDER BY spesialisasi");
    $dokter->execute(['rumahsakit_id' => $rumahsakit_id]);
    $dokter_rs = $dokter->fetchAll(PDO::FETCH_ASSOC);
 
     if (!$dokter_rs) {
     die("Doctor not found.");
     }
    
     $query = "
        SELECT *
        FROM pasien p
        JOIN riwayat r ON p.NIK = r.NIK
        WHERE r.rumahsakit_id = :rumahsakit_id
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
    <link rel="stylesheet" href="dashboard-rs/output.css" />
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
      <div class="w-64 bg-gradient-to-b from-cyan-950 to-teal-500 p-4 shadow-lg text-white">
        <h2 class="text-2xl font-bold mb-4 text-gray-200"><?php echo htmlspecialchars($rumah_sakit['nama_rumahsakit']); ?></h2>
        <ul class="text-xl font-bold text-gray-200">
          <li>
            <a href="#" class="block py-1 px-3 rounded hover:bg-gray-600 hover:text-white" onclick="showTenagaMedis()">Tenaga Medis</a>
          </li>
          <li>
            <a href="#" class="block py-1 px-3 rounded hover:bg-gray-600 hover:text-white" onclick="showPasien()">Pasien</a>
          </li>
          <li>
            <a href="#" class="block py-1 px-3 rounded hover:bg-gray-600 hover:text-white">Tambah Riwayat</a>
          </li>
        </ul>
      </div>
      <div class="flex-1 p-10 text-2xl font-bold">
        <div id="content" class="flex flex-col">
          <div class="h-[90vh] flex flex-col items-center justify-center ">
            <div class="flex flex-col text-gray-600">
              <h1 class="flex justify-start text-[100px] m-14">Halo</h1>
              <h1 class="flex justify-end text-[80px]">Selamat Datang!</h1>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script>
      let originalContent;


      window.onload = function () {
        originalContent = document.getElementById("content").innerHTML;
      };

      const tenagaMedis = `
        <div class="flex flex-row justify-between">
          <h1 class="text-black">Daftar Tenaga Medis <?php echo htmlspecialchars($rumah_sakit['nama_rumahsakit']); ?></h1>
          <div>
            <input type="text" id="searchBar" class="search-bar" onkeyup="filterDoctors()" placeholder="Search for doctors..">
            <button class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
              Keluar
            </button>
          </div>  
        </div>
        <div class="h-[80vh] overflow-y-scroll rounded-lg">
          <ul id="doctorList">
            <?php foreach ($dokter_rs as $doks) : ?>
              <li class="doctor-item">
                <div class="flex items-center">
                  <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                  <div>
                    <p class="text-sm doctor-name"><?php echo htmlspecialchars($doks['nama_tenagamedis']); ?></p>
                    <p class="text-xs text-gray-400"><?php echo htmlspecialchars($doks['spesialisasi']); ?></p>
                  </div>
                </div>
                <div>
                  <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Tenaga Medis View', '<?php echo $doks['tenagamedis_id']; ?>', '<?php echo htmlspecialchars($doks['nama_tenagamedis']); ?>')">View</button>
                </div>
              </li>
            <?php endforeach; ?>
          </ul>
        </div>
        <div class="flex justify-center my-4">
          <a href="../index.php" class="p-2 rounded-lg bg-gray-400 hover:bg-teal-500 text-white">Tambah Tenaga Medis</a>
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
          <h1 class="text-black">Daftar Pasien <?php echo htmlspecialchars($rumah_sakit['nama_rumahsakit']); ?></h1>
          <div>
            <input type="text" id="searchBarPasien" class="search-bar" onkeyup="filterPatients()" placeholder="Search for patients..">
            <button class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
              Keluar
            </button>
          </div>
        </div>
        <div class="h-[80vh] overflow-y-scroll rounded-lg">
          <ul id="patientList">
            <?php foreach ($patients as $patient) : ?>
              <li class="list-item">
                <div class="flex items-center">
                  <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                  <div>
                    <p class="text-sm patient-name"><?php echo htmlspecialchars($patient['nama_pasien']); ?></p>
                    <p class="text-xs text-gray-400"><?php echo htmlspecialchars($patient['NIK']); ?></p>
                  </div>
                </div>
                <div>
                  <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Pasien View', '<?php echo $patient['NIK']; ?>', '<?php echo htmlspecialchars($patient['nama_pasien']); ?>')">View</button>
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
        <button
                    class="absolute mr-4 font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
                    Keluar
                </button>
        <div class="flex flex-col items-center justify-center h-[90vh]">
        <h1 class="flex justify-center my-4 text-2xl text-gray-600">Tambah Riwayat</h1>
         

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
            case "Tenaga Medis":
            content.innerHTML = tenagaMedis;
            break;
            case "Tenaga Medis View":
            // Fetch patient list for the selected doctor
            // content.innerHTML = tenagaMedisView;
            fetchPatients(id, nama);
            break;
            case "Pasien":
            content.innerHTML = pasien;
            break;
            case "Pasien View":
            // content.innerHTML = pasienView;
            fetchPatientsView(id, nama);
            break;
            case "Detail Riwayat":
            // content.innerHTML = detailRiwayat;
            fetchPatientViewFull(id, nama);
            break;
            case "Tambah Riwayat":
            content.innerHTML = tambahRiwayat;
            break;
            default:
            content.innerHTML = originalContent;
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
                    <h1 class="text-black">Riwayat Pasien ${namaTenagaMedis}</h1>
                    <button class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
                        Keluar
                    </button>
                </div>
                <div class="h-[90vh] overflow-y-scroll rounded-lg my-auto">
                    <ul>
            `;
            patients.forEach(patient => {
                patientListHTML += `
                    <li class="flex items-center justify-between shadow-md m-4 rounded-lg">
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
                    <h1 class="text-black">Riwayat  - ${namaPasien}</h1>
                    <button class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
                        Keluar
                    </button>
                </div>
                <div class="h-[90vh] overflow-y-scroll rounded-lg my-auto">
                    <ul>
            `;
            patients.forEach(patient => {
                patientListHTML += `
                    <li class="flex items-center justify-between shadow-md m-4 rounded-lg">
                        <div class="flex flex-row">
                            <img src="dashboard-rs/avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
                            <div class="flex items-center justify-center flex-col">
                                <p class="text-sm">${patient.jenis_layanan} - ${patient.keterangan_penyakit}</p>
                                <p class="text-xs text-gray-400">Tanggal: ${patient.tanggal_riwayat}</p>
                            </div>
                        </div>
                        <div>
                            <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Detail Riwayat', '${patient.NIK}', '${patient.jenis_layanan} - ${patient.keterangan_penyakit}')">Detail</button>
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

        async function fetchPatientViewFull(NIK, keterangan) {
            console.log(NIK);
            try {
                const response = await fetch(`fetch_patientsviewfull.php?NIK=${NIK}`);
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

        function viewPatientDetailFull(patients, keterangan) {
        // Ambil hanya satu pasien pertama dari array patients
        const patient = patients[0];

        let patientDetailHTML = `
            <div class="flex flex-row justify-between">
                <h1 class="text-black">${keterangan}</h1>
                <button class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
                    Keluar
                </button>
            </div>
            <div class="h-[90vh] overflow-y-scroll rounded-lg my-auto">
                <div class="flex flex-col items-center justify-center h-[90vh]">
                    
                    <h1 class="flex justify-center my-4 text-2xl text-gray-600">Detail Riwayat</h1>
                    <form class="space-y-6 p-12 bg-white rounded-lg shadow-md text-gray-600 w-[30%]">
                        <div class="flex flex-row justify-between items-center">
                            <p for="nik">NIK:</p>
                            <p id="nik">${patient.NIK}</p>
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
    </script>
  </body>
</html>
