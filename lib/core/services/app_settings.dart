import 'package:flutter/foundation.dart';

class AppSettings {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  final ValueNotifier<bool> effectsEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<bool> narrationEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<bool> randomQuiz = ValueNotifier<bool>(true);
  final ValueNotifier<bool> fullscreen = ValueNotifier<bool>(false);
  final ValueNotifier<double> musicVolume = ValueNotifier<double>(0.65);
  final ValueNotifier<double> effectsVolume = ValueNotifier<double>(1.0);
  final ValueNotifier<double> speechRate = ValueNotifier<double>(0.48);
  final ValueNotifier<int> totalScore = ValueNotifier<int>(0);
  final ValueNotifier<int> totalCorrect = ValueNotifier<int>(0);
  final ValueNotifier<int> activitiesPlayed = ValueNotifier<int>(0);

  void resetProgress() {
    totalScore.value = 0;
    totalCorrect.value = 0;
    activitiesPlayed.value = 0;
  }
}
