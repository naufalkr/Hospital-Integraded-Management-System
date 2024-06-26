// document.getElementById("search-form").addEventListener("submit", function(event) {
//   event.preventDefault();
//   const nik = document.getElementById("search-nik").value;
//   fetch('search_patient.php', {
//     method: 'POST',
//     headers: {
//       'Content-Type': 'application/json'
//     },
//     body: JSON.stringify({ nik: nik })
//   })
//   .then(response => response.json())
//   .then(data => {
//     if (data.success) {
//       document.getElementById("patient-info").classList.remove("hidden");
//       document.getElementById("no-patient-info").classList.add("hidden");
//       document.getElementById("patient-name").textContent = data.patient.nama_pasien;
//       document.getElementById("patient-age").textContent = `AGE: ${data.patient.umur}`;
//       document.getElementById("patient-nik").textContent = data.patient.nik;
//       document.getElementById("patient-gender").textContent = data.patient.gender;
//       document.getElementById("patient-address").textContent = data.patient.alamat;
//       document.getElementById("patient-blood").textContent = data.patient.gol_darah;
//       document.getElementById("patient-allergies").textContent = data.patient.alergi;
//       document.getElementById("patient-height").textContent = `${data.patient.tinggi} cm`;
//       document.getElementById("patient-weight").textContent = `${data.patient.berat} kg`;
//       document.getElementById("patient-email").textContent = data.patient.email;
//       document.getElementById("patient-last-checkup").textContent = data.patient.last_checkup;
//     } else {
//       document.getElementById("patient-info").classList.add("hidden");
//       document.getElementById("no-patient-info").classList.remove("hidden");
//     }
//   })
//   .catch(error => {
//     console.error('Error:', error);
//   });
// });


document.getElementById("open-modal-btn").addEventListener("click", () => {
    document.getElementById("modal-wrapper").classList.remove("hidden");
  });
  
  document.getElementById("close-modal-btn").addEventListener("click", () => {
    document.getElementById("modal-wrapper").classList.add("hidden");
  });
  
  
  // Select all buttons with class 'open-modal-btn'
document.querySelectorAll(".open-modal-btn").forEach(button => {
    button.addEventListener("click", () => {
      const reportId = button.getAttribute("data-id");
      // Mengirim permintaan AJAX untuk mendapatkan informasi riwayat
      console.log(reportId);
      fetch('get_report_info.php?id=' + reportId)
      .then(response => response.json())
      .then(data => {
        // console.log(data); // Periksa respons di konsol browser
        // Menetapkan nilai dari data yang diterima ke elemen-elemen di modal-wrapper
        document.querySelector("#modal-wrapper .date").textContent = data.tanggal_riwayat;
        document.querySelector("#modal-wrapper .doctor-name").textContent = data.nama_tenagamedis;
        document.querySelector("#modal-wrapper .hospital-name").textContent = data.nama_rumahsakit;
        document.querySelector("#modal-wrapper .medicine").textContent = data.nama_obat;
        document.querySelector("#modal-wrapper .details").textContent = data.keterangan_penyakit;
        document.getElementById("modal-wrapper").classList.remove("hidden");
          // Tampilkan modal
        })
        
        .catch(error => console.error('Error:', error));
    });
  });
  