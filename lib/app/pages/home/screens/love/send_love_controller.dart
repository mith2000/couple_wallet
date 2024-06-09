import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../data/src/keys/app_key.dart';
import '../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utilities/messaging_service.dart';
import '../../../../components/feature/home/home_app_bar.dart';
import '../../../../components/feature/home/home_heart_icon.dart';
import '../../../../components/feature/love/love_message_widget.dart';
import '../../../../components/feature/love/send_love_input.dart';
import '../../../../components/feature/shortcut/bottomSheet/shortcut_bottom_sheet_controller.dart';
import '../../../../theme/app_theme.dart';
import '../../home_controller.dart';

part 'send_love_screen.dart';

const sendButtonCoolDownSecond = 60;

class SendLoveController extends GetxController {
  final AppSharedPref _pref = Get.find();
  final TextEditingController mainTextEC = TextEditingController();

  // If text field is empty => Hide the Send button
  final RxBool isTextFieldEmpty = true.obs;

  // If send button is waiting for cool down
  final RxBool isSendButtonWaiting = false.obs;

  // Send button text base on its state
  final RxString sendButtonText = RxString(R.strings.send.tr);

  final RxnInt shortcutSelectedIndex = RxnInt();
  List<String> shortcutContent = [];

  List<String> messages = [
    "Hello World!",
  ];

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<ShortcutBottomSheetController>()) {
      Get.put<ShortcutBottomSheetController>(ShortcutBottomSheetController());
    }
    shortcutContent = Get.find<ShortcutBottomSheetController>().shortcutContent;
    messages.addAll(shortcutContent);
    mainTextEC.addListener(onFieldChange);
  }

  @override
  void onClose() {
    super.onClose();
    mainTextEC.dispose();
  }

  final DateTime loveStartDate = DateTime(2022, 11, 13);

  String countLoveDays() {
    final now = DateTime.now();
    final days = now.difference(loveStartDate).inDays;
    return '$days';
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

  void onSubmit(BuildContext context) {
    // Get string content
    final stringContent = mainTextEC.text.trim();

    // Clear & Un-focus to off the keyboard
    mainTextEC.clear();
    shortcutSelectedIndex.value = null;
    FocusManager.instance.primaryFocus?.unfocus();

    String partnerAddress = _pref.getString(AppPrefKey.partnerAddress, '');
    if (partnerAddress.isNotEmpty) {
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
                  R.strings.wordsOfLoveHaveBeenSent.tr,
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

  void onFieldChange() {
    isTextFieldEmpty.value = mainTextEC.text.trim().isEmpty;
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
