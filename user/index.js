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

document.getElementById("open-modal-btn").addEventListener("click", () => {
  document.getElementById("modal-wrapper").classList.remove("hidden");
});

document.getElementById("close-modal-btn").addEventListener("click", () => {
  document.getElementById("modal-wrapper").classList.add("hidden");
});
