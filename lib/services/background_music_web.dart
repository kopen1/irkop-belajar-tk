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

    _starting = true;
    _context ??= web.AudioContext();
    _resumeAndStart();
  }

  Future<void> _resumeAndStart() async {
    try {
      final context = _context;
      if (context == null || !enabled.value) return;

      // Browser tab switching can suspend an AudioContext. Await the resume
      // operation and swallow browser autoplay/visibility-policy rejections
      // instead of leaving an unhandled JS promise that can break the page.
      try {
        await context.resume();
      } catch (_) {
        return;
      }

      if (!enabled.value || _timer != null) return;
      _playNext();
      _timer = Timer.periodic(
        const Duration(milliseconds: 420),
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
      gain.gain.value = .45 * AppSettings.instance.musicVolume.value;

      oscillator.connect(gain);
      gain.connect(context.destination);
      oscillator.start();

      Future<void>.delayed(const Duration(milliseconds: 340), () {
        try {
          oscillator.stop();
          oscillator.disconnect();
          gain.disconnect();
        } catch (_) {
          // The browser may invalidate an audio node while a tab is hidden.
        }
      });

      _index = (_index + 1) % _notes.length;
    } catch (_) {
      // Audio can be temporarily unavailable while a browser tab changes
      // visibility. Keep the app alive and let a later start recover it.
    }
  }
}
