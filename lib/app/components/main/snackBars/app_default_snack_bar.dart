part of 'app_base_snack_bar.dart';

enum AppSnackBarVariant { centered, danger }

class AppDefaultSnackBar extends AppBaseSnackBar {
  final AppSnackBarVariant variant;

  AppDefaultSnackBar({
    required super.content,
    required super.context,
    super.action,
    super.duration,
  }) : variant = AppSnackBarVariant.centered {
    final size = MediaQuery.of(context).size;
    margin = EdgeInsets.only(
      // from the middle of the app
      bottom: size.height * 0.5 - snackBarM3Height / 2 - navBarHeight / 2,
      left: size.width * 0.25,
      right: size.width * 0.25,
    );

    opacity = snackBarCenteredOpacity;
  }

  // Display on top and User no need to do action
  AppDefaultSnackBar.inform({
    required super.content,
    required super.context,
    super.duration,
  }) : variant = AppSnackBarVariant.danger {
    final size = MediaQuery.of(context).size;
    margin = EdgeInsets.only(
      // from the top of the app
      bottom: size.height * 0.75,
      left: size.width * 0.1,
      right: size.width * 0.1,
    );

    opacity = snackBarDangerOpacity;
  }

  @override
  void show() {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: margin,
      backgroundColor: AppColors.of.mainTextColor.withOpacity(
        opacity ?? snackBarCenteredOpacity,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeExt.of.dimen(4)),
      ),
      elevation: 0,
      duration: duration ?? snackBarDisplayDuration,
      content: content,
      action: action,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
