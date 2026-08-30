import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

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

    _context ??= web.AudioContext();
    _context!.resume();
    _playNext();
    _timer = Timer.periodic(
      const Duration(milliseconds: 420),
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

    final oscillator = context.createOscillator();
    final gain = context.createGain();

    oscillator.frequency.value = _notes[_index];
    // Dinaikkan agar musik terdengar lebih jelas di perangkat mobile.
    gain.gain.value = .14;

    oscillator.connect(gain);
    gain.connect(context.destination);
    oscillator.start();

    Future<void>.delayed(const Duration(milliseconds: 340), () {
      oscillator.stop();
      oscillator.disconnect();
      gain.disconnect();
    });

    _index = (_index + 1) % _notes.length;
  }
}
