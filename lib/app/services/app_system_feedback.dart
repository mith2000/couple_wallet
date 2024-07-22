import 'package:vibration/vibration.dart';

const lightFeedbackDuration = 50;

class AppSystemFeedback {
  static Future<void> lightFeedback() async {
    final hasVibrator = await Vibration.hasVibrator();
    final hasCustomVibrator = await Vibration.hasCustomVibrationsSupport();
    if (hasVibrator == true && hasCustomVibrator == true) {
      Vibration.vibrate(duration: lightFeedbackDuration);
    }
  }
}
