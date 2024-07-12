import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../domain/domain.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utilities/logs.dart';
import '../../../../components/feature/home/home_app_bar.dart';
import '../../../../components/feature/setting/fcm_token_input.dart';
import '../../../../components/feature/setting/setting_change_language.dart';
import '../../../../components/feature/setting/setting_row.dart';
import '../../../../components/main/dialogs/app_base_dialog.dart';
import '../../../../components/main/text/highlight_headline_text.dart';
import '../../../../services/app_error_handling_service.dart';
import '../../../../services/app_locale_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../uikit/uikit_controller.dart';

part 'setting_screen.dart';

class SettingController extends GetxController {
  final GetUserFcmTokenUseCase _getUserFcmTokenUseCase = Get.find();
  final GetPartnerFcmTokenUseCase _getPartnerFcmTokenUseCase = Get.find();
  final SavePartnerFcmTokenUseCase _savePartnerFcmTokenUseCase = Get.find();

  final TextEditingController yourAddressTextEC = TextEditingController();
  final TextEditingController partnerAddressTextEC = TextEditingController();

  final RxBool isPartnerLocked = false.obs;
  final RxBool isShowQuickPaste = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserFCMToken();
    loadPartnerAddress();
  }

  void onShareUserAddress() async {
    Share.share(yourAddressTextEC.text);
  }

  void onPasteToPartnerAddress() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    final cText = cdata?.text ?? "";
    if (cText.isNotEmpty && partnerAddressTextEC.text.isEmpty) {
      partnerAddressTextEC.text = cText;
      isPartnerLocked.value = true;
    }
  }

  void onLockPartnerInput(BuildContext context) async {
    if (isPartnerLocked.value) {
      isPartnerLocked.value = false;
    } else {
      if (partnerAddressTextEC.text.isEmpty) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
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
    try {
      await _savePartnerFcmTokenUseCase.execute(request: SimpleParam(partnerAddress));
    } on AppException catch (e) {
      Logs.e("savePartnerAddress failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getUserFCMToken() async {
    try {
      final response = await _getUserFcmTokenUseCase.execute();
      final value = (response.netData as SimpleModel<String?>).value;
      if (value != null && value.isNotEmpty) {
        yourAddressTextEC.text = value;
      } else {
        // TODO Request permission again
        // TODO Check if permission is granted
      }
    } on AppException catch (e) {
      Logs.e("getUserFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getPartnerFCMToken() async {
    try {
      final response = await _getPartnerFcmTokenUseCase.execute();
      final value = (response.netData as SimpleModel<String>).value;
      if (value != null && value.isNotEmpty) {
        partnerAddressTextEC.text = value;
      }
    } on AppException catch (e) {
      Logs.e("getPartnerFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  void loadPartnerAddress() {
    getPartnerFCMToken();
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
  }
}
