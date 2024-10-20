import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/resources.dart';
import '../components/main/snackBars/app_base_snack_bar.dart';
import '../theme/app_animations.dart';
import '../theme/app_icons.dart';

class NetworkConnectionService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  /// Mark the app when the connection returned
  bool isLostConnection = false;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isLostConnection = true;
      AppDefaultSnackBar.inform(
        context: Get.context!,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(R.strings.noInternetConnection.tr)),
            AppAnimations.asset(EAppAnim.connectionLost, repeat: true),
          ],
        ),
        // Animation duration
        duration: const Duration(milliseconds: 3000),
      ).show();
    } else if (result == ConnectivityResult.wifi && isLostConnection == true) {
      isLostConnection = false;
      AppDefaultSnackBar.inform(
        context: Get.context!,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(R.strings.internetConnectionAvailable.tr)),
            AppIconsWidget.wifi,
          ],
        ),
        // Animation duration
        duration: const Duration(milliseconds: 3000),
      ).show();
    }
  }
}
