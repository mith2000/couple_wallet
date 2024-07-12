import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

part 'app_default_dialog.dart';

abstract class AppBaseDialog {
  Widget? title;
  List<Widget>? contentWidgets;
  Function? onPreBuild;
  String? primaryText;
  Function? onPrimaryPressed;
  String? secondaryText;
  Function? onSecondaryPressed;

  AppBaseDialog({
    this.title,
    this.contentWidgets,
    this.onPreBuild,
    this.primaryText,
    this.onPrimaryPressed,
    this.secondaryText,
    this.onSecondaryPressed,
  });

  // Wished to use method showDialog from Flutter framework
  // But there is an issue that the dialog cannot rebuild when it is shown
  Widget build(BuildContext context);

  void show(BuildContext context);
}
