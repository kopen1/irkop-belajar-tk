import 'dart:js_interop';

import 'package:web/web.dart' as web;

class FullscreenService {
  static Future<void> setFullscreen(bool enabled) async {
    try {
      if (enabled) {
        await web.document.documentElement?.requestFullscreen().toDart;
      } else if (web.document.fullscreenElement != null) {
        await web.document.exitFullscreen().toDart;
      }
    } catch (_) {
      // Browser dapat menolak fullscreen jika aksi tidak berasal dari gestur pengguna.
    }
  }
}
