// const content = document.getElementById("content");
// const addContentButton = document.getElementById("tambahButton");

// function getNotes() {
//   return JSON.parse(localStorage.getItem("list-notes")) || [];
// }

// function saveNotes(notes) {
//   localStorage.setItem("list-notes", JSON.stringify(notes));
// }

// function createNoteElement(id, content) {
//   const element = document.createElement("textarea");

//   element.classList.add("note");
//   element.classList.add("bg-gray-100");
//   element.classList.add("border");
//   element.classList.add("border-gray-300");
//   element.classList.add("rounded-md");
//   element.classList.add("p-2");
//   element.classList.add("resize-none");
//   element.value = content;
//   element.placeholder = "Masukkan catatan disini";

//   element.addEventListener("input", (e) => {});

//   return element;
// }

// function addNote() {}

const tenagaMedisView = `
      <div class="flex flex-row justify-between">
      <div class="flex-col">
        <h3 class="text-xl mb-4">Tenaga Medis</h3>
          <h3 class="text-xl mb-4">Nama: Irfan Jackson</h3>
          <h3 class="text-xl mb-4">Spesialisasi: Dokter Bedah</h3>
          <h3 class="text-xl mb-4">Jenis Kelamin: Laki-laki</h3>
          <h3 class="text-xl mb-4">No Telpon: 08999999999</h3>
          </div>
      <h1>foto</h1>
      </div>
        
      `;

const tenagaMedis = `
 <h1 class="text-teal-500">Search</h1>
  <div class="h-[60vh] overflow-y-scroll rounded-lg">
    <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between py-2 shadow-md m-4">
      <div class="flex items-center">
        <img src="profile_picture_${
          i + 1
        }.jpg" class="w-10 h-10 rounded-full mr-2">
        <span>Dokter ${i + 1}</span>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1" onclick="switchContent('Tenaga Medis View')">View</button>
        <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1">Delete</button>
      </div>
      </li>
    `
    ).join("")}
    </ul>
  </div>
  `;

const pasienView = `
       <div class="flex flex-row justify-between">
      <div class="flex-col">
        <h3 class="text-xl mb-4">Pasien</h3>
          <h3 class="text-xl mb-4">Nama: Naufal Habibi</h3>
          <h3 class="text-xl mb-4">Tanggal Lahir: 1 Januari 2001</h3>
          <h3 class="text-xl mb-4">Alamat: Jalan Maaf Telat ngerjainnya guys :'</h3>
          <h3 class="text-xl mb-4">No Telpon: 08999999999</h3>
          <h3 class="text-xl mb-4">Email: maaftelat@gmail.com </h3>
          <h3 class="text-xl mb-4">Jenis Kelamin: Laki-laki</h3>
          </div>
      <h1>foto</h1>
      </div>
      `;

const pasien = `
 <h1 class="text-teal-500">Search</h1>
  <div class="h-[60vh] overflow-y-scroll rounded-lg">
    <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between py-2 shadow-md m-4">
      <div class="flex items-center">
        <img src="profile_picture_${
          i + 1
        }.jpg" class="w-10 h-10 rounded-full mr-2">
        <span>Pasien ${i + 1}</span>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1" onclick="switchContent('Pasien View')">View</button>
        <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1">Delete</button>
      </div>
      </li>
    `
    ).join("")}
    </ul>
  </div>
  `;

const rumahSakitView = `
         <div class="flex flex-row justify-between">
      <div class="flex-col">
        <h3 class="text-xl mb-4">Rumah Sakit</h3>
          <h3 class="text-xl mb-4">Nama: Rumah Sakit Keputih</h3>
          <h3 class="text-xl mb-4">Alamat: Keputih Tegal Timur</h3>
          <h3 class="text-xl mb-4">No Telpon: 08999999999</h3>
          <h3 class="text-xl mb-4">Kota: Bangkok </h3>
          </div>
      <h1>foto??</h1>
      </div>
      `;

const rumahSakit = `
  <h1 class="text-teal-500">Search</h1>
  <div class="h-[60vh] overflow-y-scroll rounded-lg">
    <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between py-2 shadow-md m-4">
      <div class="flex items-center">
        <img src="profile_picture_${
          i + 1
        }.jpg" class="w-10 h-10 rounded-full mr-2">
        <span>Rumah Sakit ${i + 1}</span>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1" onclick="switchContent('Pasien View')">View</button>
        <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1">Delete</button>
      </div>
      </li>
    `
    ).join("")}
    </ul>
  </div>
  `;

const obatView = `
        <div class="flex flex-row justify-between">
      <div class="flex-col">
        <h3 class="text-xl mb-4">Obat</h3>
          <h3 class="text-xl mb-4">Nama: Komix</h3>
          <h3 class="text-xl mb-4">Deskripsi: Dibuat dari kulit ayam serta ekstrak lidah buaya</h3>
          </div>
      <h1>foto</h1>
      </div>
      `;

const obat = `
  <h1 class="text-teal-500">Search</h1>
  <div class="h-[60vh] overflow-y-scroll rounded-lg">
    <ul>
      ${Array.from(
        { length: 15 },
        (_, i) => `
        <li class="flex items-center justify-between py-2 shadow-md m-4">
          <div class="flex items-center">
            <img src="profile_picture_${
              i + 1
            }.jpg" class="w-10 h-10 rounded-full mr-2">
            <span>Obat ${i + 1}</span>
          </div>
          <div>
            <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1" onclick="switchContent('Obat View')">View</button>
            <button class="hover:bg-teal-500 hover:rounded-lg p-2 py-1" onclick="deleteObat(${
              i + 1
            })">Delete</button>
          </div>
        </li>
      `
      ).join("")}
    </ul>
  </div>
`;

function switchContent(contentType) {
  switch (contentType) {
    case "Tenaga Medis":
      content.innerHTML = tenagaMedis;
      break;
    case "Tenaga Medis View":
      content.innerHTML = tenagaMedisView;
      break;
    case "Pasien":
      content.innerHTML = pasien;
      break;
    case "Pasien View":
      content.innerHTML = pasienView;
      break;
    case "Rumah Sakit":
      content.innerHTML = rumahSakit;
      break;
    case "Rumah Sakit View":
      content.innerHTML = rumahSakitView;
      break;
    case "Obat":
      content.innerHTML = obat;
      break;
    case "Obat View":
      content.innerHTML = obatView;
      break;
    default:
      content.innerHTML = "";
  }
}

document.querySelectorAll("ul li a").forEach((link) => {
  link.addEventListener("click", (e) => {
    e.preventDefault();
    switchContent(e.target.innerText);
  });
});
