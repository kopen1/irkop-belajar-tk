import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../core/services/app_settings.dart';

class BackgroundMusic {
  BackgroundMusic._();

  static final BackgroundMusic instance = BackgroundMusic._();

  final ValueNotifier<bool> enabled = ValueNotifier<bool>(true);

  web.AudioContext? _context;
  Timer? _timer;
  var _index = 0;

  static const _notes = <double>[
    261.63,
    329.63,
    392.00,
    329.63,
    293.66,
    349.23,
    440.00,
    349.23,
  ];

  void start() {
    if (!enabled.value || _timer != null) return;

    final context = _context ??= web.AudioContext();

    // Resume without awaiting: this keeps the call in the browser's
    // user-gesture path and avoids losing the autoplay activation window.
    try {
      context.resume();
    } catch (_) {}

    if (!enabled.value || _timer != null) return;
    _playNext();
    _timer = Timer.periodic(
      const Duration(milliseconds: 650),
      (_) => _playNext(),
    );
  }

  void toggle() {
    enabled.value = !enabled.value;
    if (enabled.value) {
      start();
    } else {
      stop();
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _playNext() {
    if (!enabled.value) return;

    final context = _context;
    if (context == null) return;

    try {
      final oscillator = context.createOscillator();
      final gain = context.createGain();

      oscillator.type = 'sine';
      oscillator.frequency.value = _notes[_index];
      gain.gain.value = .28 * AppSettings.instance.musicVolume.value;

      oscillator.connect(gain);
      gain.connect(context.destination);
      oscillator.start();

      Future<void>.delayed(const Duration(milliseconds: 480), () {
        try {
          oscillator.stop();
          oscillator.disconnect();
          gain.disconnect();
        } catch (_) {}
      });

      _index = (_index + 1) % _notes.length;
    } catch (_) {}
  }
}
