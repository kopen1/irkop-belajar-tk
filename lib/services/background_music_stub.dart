import 'package:flutter/foundation.dart';

class BackgroundMusic {
  BackgroundMusic._();

  static final BackgroundMusic instance = BackgroundMusic._();

  final ValueNotifier<bool> enabled = ValueNotifier<bool>(false);

  void start() {}

  void stop() {}

  void toggle() {
    enabled.value = !enabled.value;
  }
}
