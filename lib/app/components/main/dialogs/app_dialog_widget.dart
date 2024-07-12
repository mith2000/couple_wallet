import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

abstract class IAppDialog {
  void show(
    BuildContext context, {
    Widget? title,
    List<Widget>? contentWidgets,
    Function? onPreBuild,
    String? primaryText,
    Function? onPrimaryPressed,
    String? secondaryText,
    Function? onSecondaryPressed,
  });
}

class AppDefaultDialog implements IAppDialog {
  @override
  void show(
    BuildContext context, {
    Widget? title,
    List<Widget>? contentWidgets,
    Function? onPreBuild,
    String? primaryText,
    Function? onPrimaryPressed,
    String? secondaryText,
    Function? onSecondaryPressed,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
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
                        onSecondaryPressed.call(),
                        Get.back(),
                      },
                      child: Text(secondaryText ?? R.strings.close.tr),
                    ),
                  if (onPrimaryPressed != null)
                    FilledButton(
                      onPressed: () => {
                        onPrimaryPressed.call(),
                        Get.back(),
                      },
                      child: Text(primaryText ?? R.strings.okay.tr),
                    ),
                ],
        );
      },
    );
  }
}
