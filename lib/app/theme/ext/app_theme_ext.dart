part of '../app_theme.dart';

class AppThemeExt {
  @protected
  final double _dimenBase = 4.0;

  AppThemeExt._();

  static AppThemeExt get of => AppThemeExt._();

  double Function(num x) get dimen => (x) => _dimenBase * x;

  double get defaultBottomPadding => _dimenBase * 2;

  BorderRadiusGeometry? Function(num x) get borderRadius =>
      (x) => BorderRadius.circular(_dimenBase * x);

  Divider get defaultDivider =>
      Divider(color: AppColors.of.dividerColor, height: 1);

  VerticalDivider get defaultVerticalDivider =>
      VerticalDivider(color: AppColors.of.dividerColor, width: 1);
}
