import 'package:couple_wallet/app/components/main/text/highlight_headline_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../data/src/keys/app_key.dart';
import '../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../resources/resources.dart';
import '../../../../components/feature/setting/fcm_token_input.dart';
import '../../../../components/feature/setting/setting_row.dart';
import '../../../../theme/app_theme.dart';
import '../../../uikit/uikit_controller.dart';

part 'setting_screen.dart';

class SettingController extends GetxController {
  final AppSharedPref _pref = Get.find();
  final TextEditingController yourAddressTextEC = TextEditingController();
  final TextEditingController partnerAddressTextEC = TextEditingController();
  final RxBool isPartnerLocked = false.obs;
  final RxBool isShowQuickPaste = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserAddress();
    loadPartnerAddress();
  }

  void onCopyFCMToken() async {
    await Clipboard.setData(ClipboardData(text: yourAddressTextEC.text));
  }

  void onPastePartnerAddress() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    final cText = cdata?.text ?? "";
    if (cText.isNotEmpty && partnerAddressTextEC.text.isEmpty) {
      partnerAddressTextEC.text = cText;
      isPartnerLocked.value = true;
    }
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

  Future<void> loadUserAddress() async {
    String? userFCMToken = await FirebaseMessaging.instance.getToken();
    if (userFCMToken != null && userFCMToken.isNotEmpty) {
      yourAddressTextEC.text = userFCMToken;
    }
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

  void onOpenLoveAddressDialog() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    final cText = cdata?.text ?? "";
    if (cText.isNotEmpty && partnerAddressTextEC.text.isEmpty) {
      isShowQuickPaste.value = true;
    }
  }

  void onCloseLoveAddressDialog(BuildContext context) {
    if (partnerAddressTextEC.text.isNotEmpty) {
      isPartnerLocked.value = true;
      savePartnerAddress(partnerAddressTextEC.text);
    }
    Navigator.of(context).pop();
  }
}
