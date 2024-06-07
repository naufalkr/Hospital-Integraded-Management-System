const content = document.getElementById("content");

const tenagaMedis = `
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

const pasien = `
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

const rumahSakit = `
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

const obat = `
        <div class="flex flex-row justify-between">
      <div class="flex-col">
        <h3 class="text-xl mb-4">Obat</h3>
          <h3 class="text-xl mb-4">Nama: Komix</h3>
          <h3 class="text-xl mb-4">Deskripsi: Dibuat dari kulit ayam serta ekstrak lidah buaya</h3>
          </div>
      <h1>foto</h1>
      </div>
      `;

const search = `
    <h1>Search</h1>
    <div style="height: 60vh; overflow-y: scroll;">
      <ul>
        ${Array.from(
          { length: 15 },
          (_, i) => `
          <li class="flex items-center justify-between py-2">
            <div class="flex items-center">
              <img src="profile_picture_${
                i + 1
              }.jpg" class="w-10 h-10 rounded-full mr-2">
              <span>Doctor ${i + 1}</span>
            </div>
            <div>
              <button class="bg-red-500">View</button>
              <button class="delete-button">Delete</button>
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
    case "Pasien":
      content.innerHTML = pasien;
      break;
    case "Rumah Sakit":
      content.innerHTML = rumahSakit;
      break;
    case "Obat":
      content.innerHTML = obat;
      break;
    case "Search":
      content.innerHTML = search;
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
