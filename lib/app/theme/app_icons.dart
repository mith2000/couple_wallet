import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/main/snackBars/app_base_snack_bar.dart';
import 'app_theme.dart';

class AppIcons {
  AppIcons._();

  static IconData link = FontAwesomeIcons.link;
  static IconData earthAmericas = FontAwesomeIcons.earthAmericas;
  static IconData earthAsia = FontAwesomeIcons.earthAsia;
  static IconData dev = FontAwesomeIcons.dev;
  static IconData solidHeart = FontAwesomeIcons.solidHeart;
  static IconData fileInvoice = FontAwesomeIcons.fileInvoice;
  static IconData chartPie = FontAwesomeIcons.chartPie;
  static IconData gear = FontAwesomeIcons.gear;
}

extension AppIconsWidget on AppIcons {
  static const Icon palette = Icon(Icons.palette_sharp);
  static const Widget shareNodes = FaIcon(FontAwesomeIcons.shareNodes);
  static const Widget lock = FaIcon(FontAwesomeIcons.lock);
  static const Widget lockOpen = FaIcon(FontAwesomeIcons.lockOpen);
  static const Widget chevronRight = FaIcon(FontAwesomeIcons.chevronRight);
  static const Widget reply = FaIcon(FontAwesomeIcons.reply, size: 18);
  static const Widget copy = FaIcon(FontAwesomeIcons.copy, size: 18);

  // using for AppErrorHandlingService
  static Widget circleExclamation = FaIcon(
    FontAwesomeIcons.circleExclamation,
    color: AppColors.of.redColor,
    size: snackBarIconSize,
  );

  // using for NetworkConnectionService
  static const Widget wifi = FaIcon(
    FontAwesomeIcons.wifi,
    color: Colors.greenAccent,
    size: snackBarIconSize,
  );
}
