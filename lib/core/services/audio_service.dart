import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final FlutterTts _tts = FlutterTts();
  bool backgroundOn = true;

  Future<void> init() async {
    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.15);
  }

  Future<void> speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> correct() async {
    await speak('Hebat! Jawaban kamu benar!');
  }

  Future<void> wrong() async {
    await speak('Belum tepat. Coba lagi ya.');
  }

  Future<void> click() async {
    if (backgroundOn) {
      await speak('');
    }
  }

  Future<void> question(String text) async {
    await speak(text);
  }

  void toggleBackground() {
    backgroundOn = !backgroundOn;
  }
}
