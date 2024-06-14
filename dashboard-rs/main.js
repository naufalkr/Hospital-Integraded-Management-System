window.onload = function () {
  // Store the original content when the page loads
  originalContent = document.getElementById("content").innerHTML;
};
// ini isinya pasien2 dari tenaga medis
const tenagaMedisView = `
<div class="flex flex-row justify-between">
<h1 class="text-black">Riwayat Dokter X</h1>
 <button
            class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
            Keluar
          </button>
</div>      <div class="h-[90vh] overflow-y-scroll rounded-lg my-auto">
   <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between shadow-md m-4 rounded-lg">
      <div class="flex flex-row">
      <img src="avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
        <div class="flex items-center justify-center flex-col">
        <p class="text-sm">Pasien ${i + 1}</p>
        <p class="text-xs text-gray-400">Opname</p>
        </div>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Detail Riwayat')">Detail</button>
      </div>
      </li>
      
    `
    ).join("")}
    </ul>
  </div>
      `;

const tenagaMedis = `
<div class="flex flex-row justify-between">
<h1 class="text-black">Daftar Tenaga Medis</h1>
 <button
            class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
            Keluar
          </button>
</div>
  <div class="h-[80vh] overflow-y-scroll rounded-lg">
   <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between shadow-md m-4 rounded-lg">
      <div class="flex flex-row">
      <img src="avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
        <div class="flex items-center justify-center flex-col">
        <p class="text-sm">Nama Dokter ${i + 1}</p>
        <p class="text-xs text-gray-400">Opname</p>
        </div>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Tenaga Medis View')">View</button>
      </div>
      </li>
    `
    ).join("")}
    </ul>
  </div>
  `;

const detailRiwayat = `
<button
            class="absolute mr-4 font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
            Keluar
          </button>
  <div class="flex flex-col items-center justify-center h-[90vh]">
  
  <h1 class="flex justify-center my-4 text-2xl text-gray-600">Detail Riwayat</h1>
  <form class="space-y-6 p-12 bg-white rounded-lg shadow-md text-gray-600 w-[30%]">
      <div class="flex flex-row justify-between items-center">
        <p for="nama">Nama:</p>
        <p id="nama">Habibi</p>
      </div>
      <div class="flex flex-row justify-between items-center">
        <p for="nik">NIK:</p>
        <p id="nik">696969</p>
      </div>
      <div class="flex flex-row justify-between items-center">
        <p for="dokter">Dokter:</p>
        <p id="dokter">Papa</p>
      </div>
      <div class="flex flex-row justify-between items-center">
        <p for="waktu">Waktu:</p>
        <p id="waktu">1 Januari 2024</p>
      </div>
      <div class="flex flex-row justify-between items-center">
        <p for="jenisLayanan">Jenis Layanan:</p>
        <p id="jenisLayanan">Opname</p>
      </div>
      <div class="flex flex-row justify-between items-center">
        <p for="penyakit">Keterangan:</p>
        <p>Sakit dah pokoe</p>
      </div>
      </form>
  </div>`;

const pasienView = `
<div class="flex flex-row justify-between">
<h1 class="text-black">Riwayat Pasien X</h1>
 <button
            class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
            Keluar
          </button>
</div>
       <div class="h-[80vh] overflow-y-scroll rounded-lg">
    <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between shadow-md m-4 rounded-lg">
      <div class="flex flex-row">
      <img src="avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
        <div class="flex items-center justify-center flex-col">
        <p class="text-sm">Jenis Layanan ${i + 1}</p>
        <p class="text-xs text-gray-400">1 Januari 2024</p>
        </div>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Detail Riwayat')">Detail</button>
      </div>
      </li>
    `
    ).join("")}
    </ul>
  </div>
      `;

const pasien = `
 <div class="flex flex-row justify-between">
<h1 class="text-black">Daftar Pasien</h1>
<button
            class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
            Keluar
          </button>
</div>
  <div class="h-[80vh] overflow-y-scroll rounded-lg">
    <ul>
    ${Array.from(
      { length: 15 },
      (_, i) => `
      <li class="flex items-center justify-between shadow-md m-4 rounded-lg">
      <div class="flex flex-row">
      <img src="avatar.jpg" class="w-20 h-20 rounded-full mx-4 my-2">
        <div class="flex items-center justify-center flex-col">
        <p class="text-sm">NIK Pasien ${i + 1}</p>
        <p class="text-xs text-gray-400">Opname</p>
        </div>
      </div>
      <div>
        <button class="hover:bg-teal-500 hover:text-white hover:rounded-lg p-2 py-1 my-2 mx-4" onclick="switchContent('Pasien View')">View</button>
      </div>
      </li>
    `
    ).join("")}
    </ul>
  </div>
  `;

const tambahRiwayat = `
<button
            class="absolute mr-4 font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6" onclick="switchContent()">
            Keluar
          </button>
<div class="flex flex-col items-center justify-center h-[90vh]">
<h1 class="flex justify-center my-4 text-2xl text-gray-600">Tambah Riwayat</h1>
    <form class="space-y-6 p-12 bg-white rounded-lg shadow-md text-gray-600">
      <div class="flex justify-between items-center">
        <label for="nama" class="w-1/3">Nama:</label>
        <input type="text" id="nama" name="nama" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
      </div>
      <div class="flex justify-between items-center">
        <label for="nik" class="w-1/3">NIK:</label>
        <input type="text" id="nik" name="nik" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
      </div>
      <div class="flex justify-between items-center">
        <label for="dokter" class="w-1/3">Dokter:</label>
        <input type="text" id="dokter" name="dokter" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
      </div>
      <div class="flex justify-between items-center">
        <label for="waktu" class="w-1/3">Waktu:</label>
        <input type="date" id="waktu" name="waktu" class="w-2/3 rounded-lg shadow-md bg-gray-100">
      </div>
      <div class="flex justify-between items-center">
        <label for="jenisLayanan" class="w-1/3">Jenis Layanan:</label>
        <input type="text" id="jenisLayanan" name="jenisLayanan" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
      </div>
      <div class="flex justify-between items-center">
        <label for="keterangan" class="w-1/3">Keterangan:</label>
        <input type="text" id="keterangan" name="keterangan" class="w-2/3 rounded-lg shadow-md bg-gray-100 ">
      </div>
      </form>
      <input type="submit" value="Submit" class="flex my-4 mx-auto p-2 rounded-lg bg-gray-400 cursor-pointer hover:bg-teal-500 hover:text-white">
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
    case "Detail Riwayat":
      content.innerHTML = detailRiwayat;
      break;
    case "Tambah Riwayat":
      content.innerHTML = tambahRiwayat;
      break;
    default:
      content.innerHTML = originalContent;
  }
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
