import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/resources.dart';

class AppErrorHandlingService extends GetxService {
  void showErrorSnackBar(String errorMessage) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(errorMessage),
      action: SnackBarAction(
        label: R.strings.close.tr,
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
