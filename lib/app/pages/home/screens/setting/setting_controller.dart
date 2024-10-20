import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../domain/domain.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utilities/logs.dart';
import '../../../../components/feature/home/home_app_bar.dart';
import '../../../../components/feature/setting/fcm_token_input.dart';
import '../../../../components/feature/setting/setting_change_language.dart';
import '../../../../components/feature/setting/setting_row.dart';
import '../../../../components/main/dialogs/app_base_dialog.dart';
import '../../../../components/main/snackBars/app_base_snack_bar.dart';
import '../../../../components/main/text/highlight_headline_text.dart';
import '../../../../services/app_error_handling_service.dart';
import '../../../../services/app_locale_service.dart';
import '../../../../theme/app_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../uikit/uikit_controller.dart';

part 'setting_screen.dart';

class SettingController extends GetxController {
  final GetUserFcmTokenUseCase getUserFcmTokenUseCase;
  final GetPartnerFcmTokenUseCase getPartnerFcmTokenUseCase;
  final SavePartnerFcmTokenUseCase savePartnerFcmTokenUseCase;

  final TextEditingController yourAddressTextEC = TextEditingController();
  final TextEditingController partnerAddressTextEC = TextEditingController();

  final RxBool isPartnerLocked = false.obs;
  final RxBool isShowQuickPaste = false.obs;

  RxString appVersion = "--".obs;
  RxString appBuildNumber = "--".obs;

  SettingController({
    required this.getUserFcmTokenUseCase,
    required this.getPartnerFcmTokenUseCase,
    required this.savePartnerFcmTokenUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    getUserFCMToken();
    loadPartnerAddress();
    getPackageInfo();
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
        AppDefaultSnackBar.inform(
          context: context,
          content: Text(R.strings.pleaseInputYourPartnerAddress.tr),
        ).show();
        return;
      }
      isPartnerLocked.value = true;
      savePartnerAddress(partnerAddressTextEC.text);
    }
  }

  Future<void> savePartnerAddress(String partnerAddress) async {
    try {
      await savePartnerFcmTokenUseCase(request: SimpleParam(partnerAddress));
    } on AppException catch (e) {
      Logs.e("savePartnerAddress failed with ${e.toString()}");
      if (e.errorCode == ErrorCode.lackOfInputError) {
        Get.find<AppErrorHandlingService>().showErrorSnackBar(R.strings.saveFailed.tr);
        return;
      }
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getUserFCMToken() async {
    try {
      final response = await getUserFcmTokenUseCase();
      final value = (response.netData as SimpleModel<String?>).value;
      if (value != null && value.isNotEmpty) {
        yourAddressTextEC.text = value;
      } else {}
    } on AppException catch (e) {
      Logs.e("getUserFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getPartnerFCMToken() async {
    try {
      final response = await getPartnerFcmTokenUseCase();
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

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
  }
}
