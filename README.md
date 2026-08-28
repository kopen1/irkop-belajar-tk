# IRKOP — Bermain Sambil Belajar TK

Prototype Flutter yang mengikuti visual mockup yang disetujui: ceria, pastel, rounded cards, karakter emoji sebagai placeholder karakter final, audio di setiap interaksi, backsound ON/OFF, warna mengubah background, dan kuis dengan suara/effect benar maupun salah.

## Target development
1. Jalankan sebagai Flutter Web dan deploy ke GitHub Pages terlebih dahulu.
2. Fix seluruh UI/UX dan validasi di Pages.
3. Setelah status finish, baru build APK release.

## Audio
- `flutter_tts` untuk narasi/pelafalan Bahasa Indonesia.
- `audioplayers` untuk click/correct/wrong/backsound.
- File WAV di `assets/audio/` adalah efek placeholder yang dapat diganti dengan audio karakter/narator final tanpa mengubah alur aplikasi.

## GitHub
Folder target user: `workspace/projects/irkop-belajar-tk`.
Repo sebaiknya dibuat dengan nama `irkop-belajar-tk` dan GitHub Pages diarahkan ke workflow Flutter Web.
