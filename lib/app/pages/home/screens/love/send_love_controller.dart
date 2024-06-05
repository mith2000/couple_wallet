import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../data/src/keys/app_key.dart';
import '../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utilities/messaging_service.dart';
import '../../../../components/feature/love/send_love_input.dart';
import '../../../../components/feature/shortcut/bottomSheet/shortcut_bottom_sheet_controller.dart';
import '../../../../theme/app_theme.dart';
import '../../home_controller.dart';

part 'send_love_screen.dart';

const mainTextFieldName = 'main';
const sendButtonCoolDownSecond = 60;

class SendLoveController extends GetxController {
  final AppSharedPref _pref = Get.find();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController mainTextEC = TextEditingController();

  // If text field is empty => Hide the Send button
  final RxBool isTextFieldEmpty = true.obs;

  // If send button is waiting for cool down
  final RxBool isSendButtonWaiting = false.obs;

  // Send button text base on its state
  final RxString sendButtonText = RxString(R.strings.send.tr);

  final RxnInt shortcutSelectedIndex = RxnInt();
  List<String> shortcutContent = [];

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<ShortcutBottomSheetController>()) {
      Get.put<ShortcutBottomSheetController>(ShortcutBottomSheetController());
    }
    shortcutContent = Get.find<ShortcutBottomSheetController>().shortcutContent;
  }

  void startCoolDownSendButton() {
    isSendButtonWaiting.value = true;
    sendButtonText.value = R.strings.wait.tr;
    const coolDown = Duration(seconds: sendButtonCoolDownSecond);
    Timer(coolDown, () {
      isSendButtonWaiting.value = false;
      sendButtonText.value = R.strings.send.tr;
    });
  }

  void onSubmit(BuildContext context) async {
    // Save & validate the form
    if (formKey.currentState?.saveAndValidate() == false) return;

    // Get string content
    final stringContent =
        (formKey.currentState?.fields[mainTextFieldName]?.value ?? '')
            .toString()
            .trim();

    // Clear & Un-focus to off the keyboard
    mainTextEC.clear();
    shortcutSelectedIndex.value = null;
    FocusManager.instance.primaryFocus?.unfocus();

    String? partnerAddress = await _pref.getString(AppPrefKey.partnerAddress);
    if (partnerAddress != null && partnerAddress.isNotEmpty) {
      onSendNotification(partnerAddress, stringContent, context);
    } else {
      onNoPartnerAddressFound(context);
    }
  }

  void onNoPartnerAddressFound(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(AppThemeExt.of.dimen(2)),
            Text(R.strings.checkPartnerAddress.tr),
          ],
        ),
        actions: <Widget>[
          FilledButton(
            child: Text(R.strings.okay.tr),
            onPressed: () {
              final homeController = Get.find<HomeController>();
              homeController.goSetting();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void onSendNotification(
    String partnerAddress,
    String stringContent,
    BuildContext context,
  ) {
    // Send message
    MessagingService.sendNotification(
      targetToken: partnerAddress,
      title: R.strings.yourLoverSentToYou.tr,
      body: stringContent,
      onSuccess: () {
        // Show snack bar
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  stringContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Lottie.asset(
                R.json.animCheck.path,
                width: 24,
                height: 24,
                repeat: false,
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Start cool down for send button
        startCoolDownSendButton();
      },
      onFail: () => onNoPartnerAddressFound(context),
    );
  }

  void onFieldChange(String? value) {
    if (value == null || value.trim().isEmpty) {
      isTextFieldEmpty.value = true;
    } else {
      isTextFieldEmpty.value = false;
    }
  }

  void onShortcutSelected(BuildContext context, bool selected, int index) {
    // Last item will open bottom sheet
    if (index == shortcutContent.length - 1) {
      ShortcutBottomSheetView.openBottomSheet(context);
      return;
    }

    shortcutSelectedIndex.value = selected ? index : null;

    if (shortcutSelectedIndex.value != null) {
      mainTextEC.text = shortcutContent[index];
    } else {
      mainTextEC.clear();
    }
  }
}
