part of 'app_base_dialog.dart';

class AppDefaultDialog extends AppBaseDialog {
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
