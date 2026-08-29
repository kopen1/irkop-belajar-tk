import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;
  bool _backgroundOn = true;

  bool get backgroundOn => _backgroundOn;

  void toggleBackground() {
    _backgroundOn = !_backgroundOn;
  }

  Future<void> init() async {
    if (_initialized) return;

    await _tts.setLanguage('id-ID');

    // Lebih cepat dan responsif.
    await _tts.setSpeechRate(0.82);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);

    // Jangan menunggu TTS selesai sebelum interaksi berikutnya.
    await _tts.awaitSpeakCompletion(false);

    _initialized = true;
  }

  Future<void> click() async {
    await init();
    try {
      await _tts.stop();
      await _tts.speak('Klik');
    } catch (_) {}
  }

  Future<void> speak(String text) async {
    final value = text.trim();
    if (value.isEmpty) return;

    await init();

    try {
      await _tts.stop();
      await _tts.speak(value);
    } catch (_) {}
  }

  Future<void> question(String text) async {
    await speak(text);
  }

  Future<void> correct() async {
    await speak('Benar! Hebat!');
  }

  Future<void> wrong() async {
    await speak('Belum tepat. Coba lagi.');
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
