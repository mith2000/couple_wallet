import 'package:flutter/animation.dart';
import 'package:lottie/lottie.dart';

import '../../resources/resources.dart';
import '../components/main/snackBars/app_base_snack_bar.dart';

class AppAnimations {
  static asset(
    EAppAnim anim, {
    double width = snackBarIconSize,
    double height = snackBarIconSize,
    bool repeat = false,
    Animation<double>? controller,
    void Function(LottieComposition)? onLoaded,
  }) =>
      Lottie.asset(
        anim.jsonPath,
        width: width,
        height: height,
        repeat: repeat,
        controller: controller,
        onLoaded: onLoaded,
      );
}

enum EAppAnim {
  check,
  connectionLost,
  heart;

  const EAppAnim();

  String get jsonPath {
    switch (this) {
      case EAppAnim.check:
        return R.json.animCheck.path;
      case EAppAnim.connectionLost:
        return R.json.animConnectionLost.path;
      case EAppAnim.heart:
        return R.json.animHeart.path;
    }
  }
}
