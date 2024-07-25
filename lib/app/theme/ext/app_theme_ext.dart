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

  Divider get defaultDivider => Divider(color: AppColors.of.dividerColor, height: 1);

  VerticalDivider get defaultVerticalDivider =>
      VerticalDivider(color: AppColors.of.dividerColor, width: 1);

  List<BoxShadow> defaultShadow({bool reversed = false}) => [
        BoxShadow(
          color: AppColors.of.tealColor[10]?.withOpacity(0.04) ?? Colors.grey,
          offset: reversed ? const Offset(-2, -4) : const Offset(2, 4),
          blurRadius: 14,
          spreadRadius: 0,
        ),
      ];
}
