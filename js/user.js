// Tab functionality
const medicalReportsTab = document.getElementById("medical-reports-tab");
const prescriptionsTab = document.getElementById("schedule-tab");
const medicalReportsContent = document.getElementById(
  "medical-reports-content"
);
const prescriptionsContent = document.getElementById("schedule-content");

medicalReportsTab.addEventListener("click", () => {
  medicalReportsContent.classList.add("active");
  prescriptionsContent.classList.remove("active");
  medicalReportsTab.classList.add("bg-teal-500", "text-white");
  medicalReportsTab.classList.remove("text-gray-500");
  prescriptionsTab.classList.add("text-gray-500");
  prescriptionsTab.classList.remove("bg-teal-500", "text-white");
});

prescriptionsTab.addEventListener("click", () => {
  prescriptionsContent.classList.add("active");
  medicalReportsContent.classList.remove("active");
  prescriptionsTab.classList.add("bg-teal-500", "text-white");
  prescriptionsTab.classList.remove("text-gray-500");
  medicalReportsTab.classList.add("text-gray-500");
  medicalReportsTab.classList.remove("bg-teal-500", "text-white");
});

const patientData = {
  nik: "",
  gender: "",
  address: "",
  bloodType: "",
  allergies: "",
  height: "",
  weight: "",
  email: "",
  lastCheckUp: "",
};

// Function to populate data
function populatePatientData(data) {
  document.getElementById("nik").textContent = data.nik;
  document.getElementById("gender").textContent = data.gender;
  document.getElementById("address").textContent = data.address;
  document.getElementById("blood-type").textContent = data.bloodType;
  document.getElementById("allergies").textContent = data.allergies;
  document.getElementById("height").textContent = data.height;
  document.getElementById("weight").textContent = data.weight;
  document.getElementById("email").textContent = data.email;
  document.getElementById("last-check-up").textContent = data.lastCheckUp;
}

// Populate the data when the document is ready
document.addEventListener("DOMContentLoaded", () => {
  populatePatientData(patientData);
});

function toggleDetails(button) {
  const card = button.closest(".card");
  const details = card.querySelector(".card-details");
  const icon = button.querySelector(".icon");

  if (details.style.display === "none" || details.style.display === "") {
    details.style.display = "flex";
    icon.setAttribute("d", "M18 12H6");
  } else {
    details.style.display = "none";
    icon.setAttribute("d", "M6 18L18 6M6 6l12 12");
  }
}

// document.getElementById("open-modal-btn").addEventListener("click", () => {
//   document.getElementById("modal-wrapper").classList.remove("hidden");
// });

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






// document.addEventListener("DOMContentLoaded", function () {
//   populatePatientData(patientData);
  
//   const modalWrapper = document.getElementById("modal-wrapper");

//   document.querySelectorAll(".open-modal-btn").forEach(button => {
//     button.addEventListener("click", function () {
//       const reportId = this.getAttribute("data-id");
//       // Fetch and display report details based on reportId
//       fetchReportDetails(reportId);
//       modalWrapper.classList.remove("hidden");
//     });
//   });

//   document.getElementById("close-modal-btn").addEventListener("click", () => {
//     modalWrapper.classList.add("hidden");
//   });

//   function fetchReportDetails(reportId) {
//     // Fetch the report details from the server or array based on the reportId
//     // For the sake of this example, we'll just update the modal content manually.
//     // In a real-world scenario, you would fetch the details via AJAX.

//     // Assuming `reports` is an array of report details available globally
//     const report = reports.find(r => r.riwayat_id === reportId);
//     if (report) {
//       document.querySelector("#modal-wrapper .date").textContent = report.date;
//       document.querySelector("#modal-wrapper .dr_name").textContent = report.dr_name;
//       document.querySelector("#modal-wrapper .place").textContent = report.place;
//       // Add other details similarly
//     }
//   }
// });


// // Add event listeners to each button
// const popupButtons = document.querySelectorAll(".icon-button");
// popupButtons.forEach(button => {
//   button.addEventListener("click", () => {
//     const card = button.closest(".card");
//     const report = {
//       tanggal_riwayat: card.querySelector(".date").textContent,
//       nama_tenagamedis: card.querySelector(".dr_name").textContent,
//       nama_rumahsakit: card.querySelector(".place").textContent
//     };
//     populatePopupDetails(report);
//     document.getElementById("modal-wrapper").classList.remove("hidden");
//   });
// });
