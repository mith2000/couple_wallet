import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

part 'app_default_snack_bar.dart';

const snackBarIconSize = 24.0;
const snackBarM3Height = 68.0;
const navBarHeight = 64.0;
const snackBarMarginTop = 100.0;
const snackBarCenteredOpacity = 0.75;
const snackBarDangerOpacity = 0.9;
const snackBarDisplayDuration = Duration(milliseconds: 4000);

abstract class AppBaseSnackBar {
  Widget content;
  BuildContext context;
  EdgeInsetsGeometry? margin;
  SnackBarAction? action;
  double? opacity;
  Duration? duration;

  AppBaseSnackBar({
    required this.content,
    required this.context,
    this.margin,
    this.action,
    this.opacity,
    this.duration,
  });

  void show();
}
