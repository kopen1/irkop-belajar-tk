# TODO — IRKOP Belajar TK

Checklist proyek ini dipakai sebagai patokan kerja. Setiap pekerjaan yang benar-benar selesai diberi tanda `[x]`. Pekerjaan yang belum diverifikasi visual di perangkat tetap `[ ]`.

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
