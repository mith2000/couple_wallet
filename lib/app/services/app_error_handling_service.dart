import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../components/main/snackBars/app_base_snack_bar.dart';
import '../theme/app_theme.dart';

class AppErrorHandlingService extends GetxService {
  void showErrorSnackBar(String errorMessage) {
    AppDefaultSnackBar.inform(
      context: Get.context!,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(errorMessage)),
          FaIcon(
            FontAwesomeIcons.circleExclamation,
            color: AppColors.of.redColor,
            size: snackBarIconSize,
          ),
        ],
      ),
    ).show();
  }
}
