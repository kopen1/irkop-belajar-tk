import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/services/app_settings.dart';

class BackgroundMusic {
  BackgroundMusic._();

  static final BackgroundMusic instance = BackgroundMusic._();

  static const _channel = MethodChannel('irkop/background_music');
  final ValueNotifier<bool> enabled = ValueNotifier<bool>(true);

  Future<void> start() async {
    if (!enabled.value) return;
    try {
      await _channel.invokeMethod('start', {
        'volume': AppSettings.instance.musicVolume.value,
      });
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
  }

  Future<void> toggle() async {
    enabled.value = !enabled.value;
    if (enabled.value) {
      await start();
    } else {
      await stop();
    }
  }
}
