import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

part 'app_default_snack_bar.dart';

const snackBarIconSize = 24.0;
const snackBarM3Height = 68.0;
const navBarHeight = 64.0;
const snackBarMarginTop = 100.0;

abstract class AppBaseSnackBar {
  Widget content;
  BuildContext context;
  EdgeInsetsGeometry? margin;
  SnackBarAction? action;

  AppBaseSnackBar({
    required this.content,
    required this.context,
    this.margin,
    this.action,
  });

  void show();
}
