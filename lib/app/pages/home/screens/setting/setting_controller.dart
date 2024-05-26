import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../data/src/keys/app_key.dart';
import '../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../resources/resources.dart';
import '../../../../components/feature/setting/fcm_token_input.dart';
import '../../../../theme/app_theme.dart';
import '../../../uikit/uikit_controller.dart';

part 'setting_screen.dart';

class SettingController extends GetxController {
  final AppSharedPref _pref = Get.find();
  final TextEditingController yourAddressTextEC = TextEditingController();
  final TextEditingController partnerAddressTextEC = TextEditingController();
  final RxBool isPartnerLocked = false.obs;

  @override
  void onInit() {
    super.onInit();
    yourAddressTextEC.text = "Hello 123";
    loadPartnerAddress();
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
      savePartnerAddress(partnerAddressTextEC.text);
    }
  }

  Future<void> savePartnerAddress(String partnerAddress) async {
    await _pref.setString(AppPrefKey.partnerAddress, partnerAddress);
  }

  Future<void> loadPartnerAddress() async {
    String? partnerAddress = await _pref.getString(AppPrefKey.partnerAddress);
    if (partnerAddress != null && partnerAddress.isNotEmpty) {
      partnerAddressTextEC.text = partnerAddress;
    }
    checkPartnerAddressToLock();
  }

  void checkPartnerAddressToLock() {
    if (partnerAddressTextEC.text.isEmpty) {
      isPartnerLocked.value = false;
    } else {
      isPartnerLocked.value = true;
    }
  }
}
