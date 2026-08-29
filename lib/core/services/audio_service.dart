import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final FlutterTts _tts = FlutterTts();

  bool backgroundOn = true;

  bool _initialized = false;
  int _requestId = 0;

  Future<void> init() async {
    if (_initialized) return;

    try {
      await _tts.setLanguage('id-ID');
      await _tts.setSpeechRate(0.48);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.08);
      await _tts.awaitSpeakCompletion(false);
      _initialized = true;
    } catch (_) {}
  }

  Future<void> stop() async {
    _requestId++;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> speak(
    String text, {
    bool interrupt = true,
  }) async {
    if (text.trim().isEmpty) return;

    await init();

    final request = ++_requestId;

    try {
      if (interrupt) {
        await _tts.stop();
      }

      if (request != _requestId) return;

      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> question(String text) async {
    await speak(
      text,
      interrupt: true,
    );
  }

  Future<void> correct() async {
    await speak(
      'Hebat! Jawaban kamu benar!',
      interrupt: true,
    );
  }

  Future<void> wrong() async {
    await speak(
      'Belum tepat. Coba lagi ya.',
      interrupt: true,
    );
  }

  Future<void> click() async {
    if (!backgroundOn) return;

    await init();

    try {
      await _tts.setPitch(1.3);
      await _tts.setSpeechRate(0.55);
      await _tts.speak('klik');
      await _tts.setPitch(1.08);
      await _tts.setSpeechRate(0.48);
    } catch (_) {}
  }

  void toggleBackground() {
    backgroundOn = !backgroundOn;
  }
}
