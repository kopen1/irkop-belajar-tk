import 'dart:async';

import 'package:web/web.dart' as web;

class BackgroundMusic {
  BackgroundMusic._();

  static final BackgroundMusic instance = BackgroundMusic._();

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
    if (_timer != null) return;

    _context ??= web.AudioContext();
    _playNext();
    _timer = Timer.periodic(
      const Duration(milliseconds: 420),
      (_) => _playNext(),
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _playNext() {
    final context = _context;
    if (context == null) return;

    final oscillator = context.createOscillator();
    final gain = context.createGain();

    oscillator.frequency.value = _notes[_index];
    gain.gain.value = .045;

    oscillator.connect(gain);
    gain.connect(context.destination);
    oscillator.start();

    Future<void>.delayed(const Duration(milliseconds: 330), () {
      oscillator.stop();
      oscillator.disconnect();
      gain.disconnect();
    });

    _index = (_index + 1) % _notes.length;
  }
}
