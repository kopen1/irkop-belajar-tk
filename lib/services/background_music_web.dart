import 'dart:async';
import 'dart:html' as html;

class BackgroundMusic {
  BackgroundMusic._();

  static final BackgroundMusic instance = BackgroundMusic._();

  html.AudioContext? _context;
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

    _context ??= html.AudioContext();
    final context = _context!;

    if (context.state == 'suspended') {
      context.resume();
    }

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

    oscillator
      ..type = 'sine'
      ..frequency.value = _notes[_index];

    gain.gain.value = .045;

    oscillator
      ..connectNode(gain)
      ..start();

    gain.connectNode(context.destination);

    Future<void>.delayed(const Duration(milliseconds: 330), () {
      oscillator.stop();
      oscillator.disconnect();
      gain.disconnect();
    });

    _index = (_index + 1) % _notes.length;
  }
}
