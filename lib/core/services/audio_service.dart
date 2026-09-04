import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'app_settings.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _backgroundOn = true;

  bool get backgroundOn => _backgroundOn;

  void toggleBackground() => _backgroundOn = !_backgroundOn;

  double _platformRate(double value) {
    final rate = value.clamp(0.30, 0.65).toDouble();
    if (!kIsWeb) return rate;
    // Web SpeechSynthesis uses ~1.0 as normal speed, while Android's
    // flutter_tts scale is naturally lower. Keep one shared setting but
    // translate it for the browser so the web voice is not unnaturally slow.
    return (rate / 0.50).clamp(0.60, 1.30).toDouble();
  }

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(_platformRate(AppSettings.instance.speechRate.value));
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);
    await _tts.awaitSpeakCompletion(false);
    _initialized = true;
  }

  Future<void> setSpeechRate(double value) async {
    final rate = value.clamp(0.30, 0.65).toDouble();
    AppSettings.instance.speechRate.value = rate;
    await init();
    try {
      await _tts.setSpeechRate(_platformRate(rate));
    } catch (_) {}
  }

  Future<void> click() async {}

  Future<void> speak(String text) async {
    if (!AppSettings.instance.narrationEnabled.value) return;
    final value = text.trim();
    if (value.isEmpty) return;
    await init();
    try {
      await _tts.stop();
      await _tts.setSpeechRate(_platformRate(AppSettings.instance.speechRate.value));
      await _tts.speak(value);
    } catch (_) {}
  }

  Future<void> question(String text) async => speak(text);
  Future<void> correct() async => speak('Benar! Hebat!');
  Future<void> wrong() async => speak('Belum tepat. Coba lagi.');

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
