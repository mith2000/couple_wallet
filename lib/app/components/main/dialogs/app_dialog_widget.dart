import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

abstract class IAppDialog {
  Widget? title;
  List<Widget>? contentWidgets;
  Function? onPreBuild;
  String? primaryText;
  Function? onPrimaryPressed;
  String? secondaryText;
  Function? onSecondaryPressed;

  IAppDialog({
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

class AppDefaultDialog extends IAppDialog {
  AppDefaultDialog({
    super.title,
    super.contentWidgets,
    super.onPreBuild,
    super.primaryText,
    super.onPrimaryPressed,
    super.secondaryText,
    super.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    onPreBuild?.call();
    return AlertDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If there is no title, need a spacing to deal with horizontal padding
          if (title == null) Gap(AppThemeExt.of.dimen(2)),
          ...?contentWidgets,
        ],
      ),
      // Check null to deal with actionPadding default by Flutter
      actions: (onSecondaryPressed == null && onPrimaryPressed == null)
          ? null
          : <Widget>[
              if (onSecondaryPressed != null)
                OutlinedButton(
                  onPressed: () => {
                    onSecondaryPressed?.call(),
                    Get.back(),
                  },
                  child: Text(secondaryText ?? R.strings.close.tr),
                ),
              if (onPrimaryPressed != null)
                FilledButton(
                  onPressed: () => {
                    onPrimaryPressed?.call(),
                    Get.back(),
                  },
                  child: Text(primaryText ?? R.strings.okay.tr),
                ),
            ],
    );
  }

  @override
  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => build(context),
    );
  }
}
