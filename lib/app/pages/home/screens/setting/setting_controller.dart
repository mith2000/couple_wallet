import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../components/feature/setting/fcm_token_input.dart';
import '../../../../theme/app_theme.dart';
import '../../../uikit/uikit_controller.dart';

part 'setting_screen.dart';

class SettingController extends GetxController {
  final TextEditingController yourAddressTextEC = TextEditingController();
  final TextEditingController partnerAddressTextEC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    yourAddressTextEC.text = "Hello 123";
  }

  void onCopyFCMToken() async {
    await Clipboard.setData(ClipboardData(text: yourAddressTextEC.text));
  }

  void onSaveFCMToken() async {}
}
