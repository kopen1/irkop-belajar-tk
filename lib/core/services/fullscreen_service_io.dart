import 'package:flutter/services.dart';

class FullscreenService {
  static Future<void> setFullscreen(bool enabled) async {
    await SystemChrome.setEnabledSystemUIMode(
      enabled ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }
}
