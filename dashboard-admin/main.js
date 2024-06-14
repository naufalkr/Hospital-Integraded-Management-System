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
<div class="flex flex-row justify-between">
<h1 class="text-black">Daftar Tenaga Medis</h1>
 <button
            class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6"
          >
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
 <div class="flex flex-row justify-between">
<h1 class="text-black">Daftar Tenaga Medis</h1>
 <button
            class="font-bold text-black rounded p-2 hover:bg-red-500 hover:text-white right-6"
          >
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
