class AudioService {
  static bool backsoundOn = true;

  static Future<void> speak(String text) async {
    // TEMP:
    // Semua pemanggilan suara dipusatkan di sini.
    // Berikutnya bisa dihubungkan ke audio asset / TTS.
  }

  static Future<void> correct() async {
    // Audio jawaban benar
  }

  static Future<void> wrong() async {
    // Audio jawaban salah
  }

  static Future<void> click() async {
    // Audio klik
  }

  static Future<void> toggleBacksound() async {
    backsoundOn = !backsoundOn;
  }
}
