# TODO — IRKOP Belajar TK

Checklist proyek ini dipakai sebagai patokan kerja. Setiap pekerjaan yang benar-benar selesai diberi tanda `[x]`. Pekerjaan yang belum diverifikasi visual di perangkat tetap `[ ]`.

## Pemeriksaan oleh User di Web

**Petunjuk:** Setelah deploy selesai, buka web versi terbaru. Untuk setiap poin:
- Ganti `[ ]` menjadi `[x]` jika berhasil/sesuai.
- Jika gagal atau belum sesuai, biarkan `[ ]` dan tulis komentar di bawah poin tersebut.
- Contoh: `Komentar: Dunia Gambar masih 1 kolom di HP.`

### 1. Home
- [X] Background langit, awan, pelangi, rumput, dan bunga tampil
  - Komentar:
- [X] Judul dan subtitle tidak terpotong di layar HP
  - Komentar:
- [ ] Kartu menu rapi dan proporsional
  - Komentar:
- [X] Tidak ada elemen keluar layar/overflow
  - Komentar:

### 2. Dunia Gambar
- [X] Di HP, 1 baris berisi tepat 2 visual
  - Komentar:
- [X] Gambar dan label tidak terpotong
  - Komentar:
- [X] Spacing dan ukuran kartu sudah sesuai blueprint
  - Komentar:        

### 3. Dunia Warna
- [X] Kotak pilihan menampilkan warna asli
  - Komentar:
- [X] Nama warna mudah dibaca
  - Komentar:
- [X] Label panjang tidak pecah aneh
  - Komentar:
- [X] Warna aktif memiliki indikator/border yang jelas
  - Komentar:

### 4. Header semua halaman
- [X] Tombol kembali berfungsi
  - Komentar:
- [X] Judul dan subtitle tidak bertabrakan dengan tombol
  - Komentar:
- [ ] Tombol musik tampil dan dapat ditekan
  - Komentar: Musik tidak ada suaranya 
- [X] Layar HP sempit tetap rapi
  - Komentar:

### 5. Dunia Huruf, Angka, dan Hijaiyah
- [ ] Grid dan kartu tampil rapi
  - Komentar:
- [ ] Visual/teks mudah dibaca
  - Komentar:
- [ ] Tidak ada overflow pada layar HP
  - Komentar:
- [ ] Warna, spacing, dan background mendekati blueprint
  - Komentar:

### 6. Mewarnai
- [ ] Gambar utama tampil utuh
  - Komentar:
- [ ] Palet warna dapat dipilih
  - Komentar:
- [ ] Warna aktif terlihat jelas
  - Komentar:
- [ ] Tidak ada bagian keluar layar
  - Komentar:

### 7. Titik & Garis
- [ ] Nomor titik tampil benar
  - Komentar:
- [ ] Garis muncul mengikuti urutan titik
  - Komentar:
- [ ] Progress/interaksi berjalan benar
  - Komentar:

### 8. Kuis Seru
- [ ] Pertanyaan tampil rapi
  - Komentar:
- [ ] Pilihan jawaban dapat dipilih
  - Komentar:
- [ ] State benar/salah tampil benar
  - Komentar:
- [ ] Pindah soal berjalan benar
  - Komentar:

### 9. Pemeriksaan akhir
- [ ] Semua halaman dapat dibuka dari Home
  - Komentar:
- [ ] Tidak ada teks atau visual yang terpotong
  - Komentar:
- [ ] Tidak ada overflow/error visual
  - Komentar:
- [ ] Hasil web sudah sesuai blueprint secara keseluruhan
  - Komentar:

## Batch berikutnya — audit visual responsif

- [ ] Cek ulang Home pada lebar 360–420 px
- [ ] Cek ulang Dunia Gambar tetap 2 kolom pada mobile
- [ ] Cek ulang Dunia Warna: palet memakai warna asli dan teks tetap terbaca
- [ ] Cek ulang header pada layar sempit

## Blueprint visual utama

- [x] Background global: langit, awan, pelangi, rumput, dan bunga
- [x] Header global: tombol kembali, kartu judul, dan tombol musik
- [x] Home responsif: 1 kolom mobile, 2 kolom tablet, 3 kolom layar lebar
- [ ] Verifikasi seluruh halaman di browser mobile terhadap blueprint visual asli
- [ ] Verifikasi seluruh halaman di browser desktop/tablet

## Halaman pembelajaran

- [x] Dunia Huruf — struktur pembelajaran dan grid huruf
- [x] Dunia Angka — struktur pembelajaran dan grid angka
- [x] Hijaiyah — struktur pembelajaran dan grid huruf Arab
- [x] Dunia Gambar — grid visual 2 kolom
- [x] Dunia Warna — pilihan warna dan perbaikan label panjang
- [ ] Cek ulang proporsi visual, ukuran kartu, warna, dan spacing semua halaman belajar

## Mini game

- [x] Mewarnai — kanvas, pilihan warna, dan indikator warna aktif
- [x] Titik & Garis — urutan titik dan progres koneksi
- [x] Kuis Seru — kartu pertanyaan dan pilihan jawaban
- [ ] Verifikasi fungsi sentuhan/interaksi di perangkat mobile
- [ ] Verifikasi semua state setelah jawaban benar/salah dan setelah pindah soal

## Audio dan UX

- [x] Tombol musik tersedia pada header
- [ ] Verifikasi suara klik dan audio pada browser mobile
- [ ] Verifikasi tidak ada elemen terpotong pada layar sempit
- [ ] Verifikasi scroll dan safe area

## Build APK

- [x] Jalankan Flutter analyze pada GitHub Actions environment
- [x] Perbaiki error analyzer yang terdeteksi pada workflow terakhir
- [ ] Jalankan Flutter test bila test tersedia
- [ ] Build APK release
- [ ] Uji APK di perangkat Android

## Aturan kerja

- [x] Perubahan fitur dibuat langsung di file proyek Flutter agar dapat dipakai juga saat build APK
- [x] Jangan mengandalkan file perbaikan sementara yang harus dibuat ulang saat build APK
- [ ] Sebelum menandai pekerjaan selesai, verifikasi hasil visual/fungsi
- [ ] Setiap pekerjaan baru ditambahkan ke checklist sebelum atau saat pengerjaan
