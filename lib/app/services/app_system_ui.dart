import 'package:flutter/services.dart';

const backgroundColor = Color(0xffFCF1DE);

class AppSystemUI {
  static Future<void> configSystemUI() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        systemNavigationBarColor: backgroundColor,
      ),
    );
  }
}
