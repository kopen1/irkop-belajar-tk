import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final FlutterTts _tts = FlutterTts();

  bool backgroundOn = true;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;

    try {
      await _tts.setLanguage('id-ID');
      await _tts.setSpeechRate(0.52);
      await _tts.setPitch(1.08);
      await _tts.setVolume(1.0);

      // Jangan menunggu suara selesai.
      // Ini membuat UI dan pertanyaan berikutnya tidak terasa lambat.
      await _tts.awaitSpeakCompletion(false);

      _ready = true;
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    await init();

    // Hentikan suara sebelumnya agar tidak mengantre.
    await stop();

    try {
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> question(String text) async {
    await speak(text);
  }

  Future<void> correct() async {
    await speak('Hebat! Jawaban kamu benar!');
  }

  Future<void> wrong() async {
    await speak('Belum tepat. Coba lagi ya.');
  }

  Future<void> click() async {
    await speak('Ya!');
  }

  void toggleBackground() {
    backgroundOn = !backgroundOn;
  }
}
