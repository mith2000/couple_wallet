import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'app_colors.dart';
part 'ext/app_theme_ext.dart';

class AppThemeData {
  AppThemeData._();

  static ThemeData lightTheme = themeData(AppColors(Brightness.light));
  static ThemeData darkTheme = themeData(AppColors(Brightness.dark));

  static ThemeData themeData(AppColors appColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: appColor.brightness,
      colorSchemeSeed: const Color(0xffde496e),
    );
  }
}
