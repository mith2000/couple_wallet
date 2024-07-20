import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/resources.dart';
import '../components/main/snackBars/app_base_snack_bar.dart';

class NetworkConnectionService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      AppDefaultSnackBar.danger(
        context: Get.context!,
        content: Text(R.strings.noInternetConnection.tr),
        action: SnackBarAction(
          label: R.strings.close.tr,
          onPressed: () {},
        ),
      ).show();
    }
  }
}
