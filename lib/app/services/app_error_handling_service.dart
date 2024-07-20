import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/main/snackBars/app_base_snack_bar.dart';

class AppErrorHandlingService extends GetxService {
  void showErrorSnackBar(String errorMessage) {
    AppDefaultSnackBar.inform(
      context: Get.context!,
      content: Text(errorMessage),
    ).show();
  }
}
