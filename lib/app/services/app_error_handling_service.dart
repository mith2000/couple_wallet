import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/main/snackBars/app_base_snack_bar.dart';
import '../theme/app_icons.dart';

class AppErrorHandlingService extends GetxService {
  void showErrorSnackBar(String errorMessage) {
    AppDefaultSnackBar.inform(
      context: Get.context!,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(errorMessage)),
          AppIconsWidget.circleExclamation,
        ],
      ),
    ).show();
  }
}
