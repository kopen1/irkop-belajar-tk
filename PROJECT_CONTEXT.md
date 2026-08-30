# PROJECT CONTEXT — IRKOP Belajar TK

Dokumen ini adalah konteks kerja untuk melanjutkan project di chat baru.

## Repository
- Repository: kopen1/irkop-belajar-tk
- Branch utama: main
- Platform: Flutter Web
- Deploy: GitHub Actions -> GitHub Pages
- URL aplikasi: https://kopen1.github.io/irkop-belajar-tk/

## Cara kerja wajib
1. User dapat mengirim beberapa request secara bertahap.
2. Semua request ditambahkan ke satu BATCH AKTIF; request terbaru tidak menggantikan request sebelumnya.
3. Sebelum "Go push", hanya tampilkan list singkat perubahan yang akan dikerjakan.
4. Setelah user berkata "Go push", kerjakan SEMUA item batch aktif sekaligus.
5. Jangan mengubah UI, struktur, tab, menu, atau fitur yang sudah ada di luar request.
6. Jika suatu request memang membutuhkan perubahan UI/struktur, jelaskan dampaknya terlebih dahulu.
7. Jika ada error build, boleh digabung ke batch agar cukup satu push dan satu build GitHub Actions.
8. Jangan menjalankan Flutter secara lokal pada lingkungan user.
9. Jangan mengklaim perubahan sudah push/deploy sebelum commit benar-benar masuk ke repository.
10. Setelah push, cek hasil GitHub Actions bila user meminta pengecekan error/build.

## Output yang diinginkan
Gunakan output singkat:
BATCH AKTIF
1. ...
2. ...
3. ...

UI/STRUKTUR: Tidak berubah.
atau jelaskan perubahan yang benar-benar diperlukan.

## Struktur utama
- lib/main.dart
  - Entry point aplikasi.
  - Home awal langsung HomePage.
  - Splash screen saat ini tidak digunakan sebagai halaman awal.
- lib/features/home/home_page.dart
  - Homepage dan navigasi seluruh fitur.
  - Tombol Pengaturan.
  - Tombol musik.
- lib/features/huruf/
  - Belajar Huruf Besar, Huruf Kecil, Mini Kuis.
- lib/features/angka/
  - Belajar Angka Indonesia, Angka Arab, Mini Kuis.
  - Mini Kuis Angka adalah referensi utama gaya UI untuk Mini Kuis lain.
- lib/features/hijaiyah/
  - Belajar Huruf Hijaiyah dan Mini Kuis.
- lib/features/gambar/
  - Belajar Gambar dan Mini Kuis.
- lib/features/warna/
  - Belajar Warna dan Mini Kuis.
- lib/features/mewarnai/
  - Mewarnai, gambar bebas, cat/fill, hapus, contoh hasil jadi.
- lib/features/titik_garis/
  - Hubungkan titik/garis dan tampilkan hasil gambar setelah selesai.
- lib/features/kuis/
  - Kuis Seru gabungan materi.
- lib/features/ibadah/
  - Doa, wudhu, sholat, gerakan dan bacaan.
  - Bacaan perlu mendukung tulisan Arab.
- lib/features/settings/
  - Halaman Pengaturan.
- lib/core/services/app_settings.dart
  - State pengaturan global.
- lib/core/services/audio_service.dart
  - TTS/narasi.
- lib/services/background_music.dart
  - Background music.
- lib/core/widgets/kid_background.dart
  - Background umum UI.

## Fitur utama yang harus dipertahankan
- Homepage UI anak-anak yang sudah disetujui.
- Tab pembelajaran tidak boleh dihilangkan saat update.
- Huruf: BESAR, KECIL, MINI KUIS.
- Angka: Indonesia, Arab, MINI KUIS.
- Hijaiyah: Huruf, MINI KUIS.
- Gambar: Gambar, MINI KUIS.
- Warna: Warna, MINI KUIS.
- Mini Kuis menggunakan pertanyaan acak jika mode random aktif.
- Musik memiliki tombol on/off.
- Pengaturan tersedia dari homepage.
- Splash screen sebelum menu saat ini harus tetap nonaktif kecuali user meminta lagi.

## Pengaturan yang ada
AppSettings saat ini mencakup:
- effectsEnabled
- narrationEnabled
- randomQuiz
- fullscreen
- musicVolume
- effectsVolume
- totalScore
- totalCorrect
- activitiesPlayed

Catatan: Saat memperbaiki fullscreen, pastikan setting fullscreen benar-benar terhubung ke implementasi web/mobile, bukan hanya ValueNotifier UI.

## Referensi UI
- Mini Kuis Angka adalah acuan visual utama untuk Mini Kuis Huruf, Hijaiyah, Gambar, dan Warna.
- Jangan melakukan redesign global saat hanya diminta memperbaiki satu fitur.
- Prioritaskan tampilan mobile tanpa scroll yang tidak perlu.

## Status error yang pernah diperbaiki
- Duplikasi initState pada lib/features/hijaiyah/hijaiyah_page.dart pernah menyebabkan GitHub Actions gagal.
- Warning WebAssembly dari flutter_tts pernah muncul, tetapi bukan error fatal build.
- Selalu cek error fatal terbaru dari log GitHub Actions sebelum mengubah dependency.

## Cara memulai di chat baru
User cukup mengatakan:
"Perbaikan project IRKOP Belajar TK: ..."
atau
"Tambahkan ke batch: ..."

Asisten harus:
1. Baca PROJECT_CONTEXT.md dan cek repository terbaru.
2. Tambahkan request ke BATCH AKTIF.
3. Jangan mengubah kode sebelum user berkata "Go push", kecuali user secara eksplisit meminta eksekusi langsung.
4. Saat "Go push", kerjakan seluruh batch aktif, bukan hanya request terakhir.


## Update Mini Kuis 2026-08-31

- Semua Mini Kuis memakai alur bersama yang sama melalui `MiniQuizPanel`.
- Total kuis: 10 soal, pilihan selalu unik dan jawaban benar hanya satu.
- Jawaban salah menampilkan karakter salah, lalu soal yang sama aktif kembali.
- Jawaban benar menampilkan karakter benar, lalu otomatis lanjut.
- Tombol manual "Soal Berikutnya" tidak dipakai di Mini Kuis.
- Setelah soal ke-10 tampil halaman Hasil Kuis dengan skor, benar, salah, bintang, dan Main Lagi.
- Karakter feedback memakai `assets/images/quiz_wrong_tiger.jpg` dan `assets/images/quiz_correct_dino.jpg`.
- Kuis Seru juga memakai karakter baru untuk hasil salah dan benar; gambar lama `quiz_dino_happy.jpg` tidak lagi dipakai untuk feedback.


## Update batch 2026-08-31

- Startup blank biru di web diganti splash visual bertema BELAJAR TK tanpa tulisan IRKOP.
- Startup aplikasi masuk ke halaman intro BELAJAR TK sebelum menu utama.
- Semua Mini Kuis memakai pertanyaan campuran sesuai materi, bukan satu pola berulang.
- Angka mencampur Latin, Arab, jumlah benda, pasangan, dan urutan.
- Huruf mencampur huruf besar/kecil, pasangan, dan gambar benda.
- Hijaiyah mencampur huruf, nama, dan pertanyaan dengar.
- Gambar mencampur nama, gambar, kategori, dan huruf awal.
- Warna dan Mewarnai mencampur nama warna, benda, dan kecocokan warna.
- Feedback benar/salah memakai layout overlay penuh dan BoxFit.contain agar karakter tidak terpotong.
