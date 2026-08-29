import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;
  bool _backgroundOn = true;

  bool get backgroundOn => _backgroundOn;

  Future<void> init() async {
    if (_initialized) return;

    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(0.85);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);
    await _tts.awaitSpeakCompletion(false);

    _initialized = true;
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    await init();

    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> click() async {}

  void toggleBackground() {
    _backgroundOn = !_backgroundOn;
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

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
