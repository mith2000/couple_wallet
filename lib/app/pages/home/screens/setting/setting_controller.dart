import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../resources/resources.dart';
import '../../../../components/feature/setting/fcm_token_input.dart';
import '../../../../theme/app_theme.dart';
import '../../../uikit/uikit_controller.dart';

part 'setting_screen.dart';

class SettingController extends GetxController {
  final TextEditingController yourAddressTextEC = TextEditingController();
  final TextEditingController partnerAddressTextEC = TextEditingController();
  final RxBool isPartnerLocked = false.obs;

  @override
  void onInit() {
    super.onInit();
    yourAddressTextEC.text = "Hello 123";
    // TODO Load the address from SharedPreferences
    checkPartnerAddressToLock();
  }

  void onCopyFCMToken() async {
    await Clipboard.setData(ClipboardData(text: yourAddressTextEC.text));
  }

  void onLockFCMToken(BuildContext context) async {
    if (isPartnerLocked.value) {
      isPartnerLocked.value = false;
    } else {
      if (partnerAddressTextEC.text.isEmpty) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 400.0,
          content: Text(R.strings.pleaseInputYourPartnerAddress.tr),
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      isPartnerLocked.value = true;
      // TODO Save the address
    }
  }

  void checkPartnerAddressToLock() {
    if (partnerAddressTextEC.text.isEmpty) {
      isPartnerLocked.value = false;
    } else {
      isPartnerLocked.value = true;
    }
  }
}
