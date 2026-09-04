import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../core/services/app_settings.dart';

class BackgroundMusic {
  BackgroundMusic._();

  static final BackgroundMusic instance = BackgroundMusic._();

  final ValueNotifier<bool> enabled = ValueNotifier<bool>(true);

  web.AudioContext? _context;
  Timer? _timer;
  StreamSubscription<web.Event>? _blurSubscription;
  StreamSubscription<web.Event>? _focusSubscription;
  var _index = 0;
  var _starting = false;

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
    if (!enabled.value || _timer != null || _starting) return;

    _bindVisibilityHandlers();
    _starting = true;
    _context ??= web.AudioContext();
    _resumeAndStart();
  }

  void _bindVisibilityHandlers() {
    if (_blurSubscription != null) return;
    _blurSubscription = web.window.onBlur.listen((_) => stop());
    _focusSubscription = web.window.onFocus.listen((_) {
      if (enabled.value) start();
    });
  }

  Future<void> _resumeAndStart() async {
    try {
      final context = _context;
      if (context == null || !enabled.value) return;

      try {
        await context.resume().toDart;
      } catch (_) {
        return;
      }

      if (!enabled.value || _timer != null) return;
      _playNext();
      _timer = Timer.periodic(
        const Duration(milliseconds: 650),
        (_) => _playNext(),
      );
    } finally {
      _starting = false;
    }
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
