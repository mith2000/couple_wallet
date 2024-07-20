import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/resources.dart';
import '../components/main/snackBars/app_base_snack_bar.dart';

class AppErrorHandlingService extends GetxService {
  void showErrorSnackBar(String errorMessage) {
    AppDefaultSnackBar.danger(
      context: Get.context!,
      content: Text(errorMessage),
      action: SnackBarAction(
        label: R.strings.close.tr,
        onPressed: () {},
      ),
    ).show();
  }
}
