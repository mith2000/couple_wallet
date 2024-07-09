import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../data/src/keys/app_key.dart';
import '../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../domain/domain.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utilities/logs.dart';
import '../../../../../utilities/messaging_service.dart';
import '../../../../adapters/love_info_adapter.dart';
import '../../../../components/feature/home/home_app_bar.dart';
import '../../../../components/feature/home/home_heart_icon.dart';
import '../../../../components/feature/love/send_love_input.dart';
import '../../../../components/feature/shortcut/bottomSheet/shortcut_bottom_sheet_controller.dart';
import '../../../../models/love_info_modelview.dart';
import '../../../../services/app_error_handling_service.dart';
import '../../../../theme/app_theme.dart';
import '../../home_controller.dart';
import 'messages/list_message_controller.dart';

part 'send_love_screen.dart';
part 'send_love_state.dart';

const sendButtonCoolDownSecond = 60;

class SendLoveController extends GetxController {
  final SendLoveState state = SendLoveState();

  final AppSharedPref _pref = Get.find();
  final GetLoveInfoUseCase _getLoveInfoUseCase = Get.find();
  final SendMessageUseCase _sendMessageUseCase = Get.find();
  late final ShortcutBottomSheetController _shortcutBottomSheetController;
  late final ListMessageController _listMessageController;

  final TextEditingController mainTextEC = TextEditingController();
  final FocusNode mainTextFocusNode = FocusNode();

  @override
  void onInit() {
    getLoveInfo();
    super.onInit();
    initListMessage();
    initShortcut();

    mainTextEC.addListener(onFieldChange);
  }

  @override
  void onClose() {
    super.onClose();
    mainTextEC.dispose();
    mainTextFocusNode.dispose();
  }

  void getLoveInfo() async {
    final response = await _getLoveInfoUseCase.execute();
    final model = response.netData;
    if (model != null) {
      ILoveInfoAdapter loveInfoAdapter = LoveInfoAdapter();
      state.loveInfo.value = loveInfoAdapter.getModelView(model);
    }
  }

  void initListMessage() {
    if (!Get.isRegistered<ListMessageController>()) {
      Get.put<ListMessageController>(ListMessageController());
    }
    _listMessageController = Get.find<ListMessageController>();
  }

  void initShortcut() {
    if (!Get.isRegistered<ShortcutBottomSheetController>()) {
      Get.put<ShortcutBottomSheetController>(ShortcutBottomSheetController());
    }
    _shortcutBottomSheetController = Get.find<ShortcutBottomSheetController>();
    state.shortcutContents.value = _shortcutBottomSheetController.shortcutContents;
  }

  void onSubmit(BuildContext context) {
    // Get string content
    final stringContent = mainTextEC.text.trim();

    resetInput();

    String partnerAddress = _pref.getString(AppPrefKey.partnerAddress, '');
    if (partnerAddress.isNotEmpty) {
      onSendNotification(partnerAddress, stringContent, context);
    } else {
      onNoPartnerAddressFound(context);
    }
  }

  void resetInput() {
    // Clear & Un-focus to off the keyboard
    mainTextEC.clear();
    state.shortcutSelectedIndex.value = null;
    FocusManager.instance.primaryFocus?.unfocus();
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
      onSuccess: () => onSendMessageSuccess(stringContent, context),
      onFail: () => onNoPartnerAddressFound(context),
    );
  }

  void onSendMessageSuccess(String stringContent, BuildContext context) {
    // Add message
    _listMessageController.addMessageToListAsOwner(stringContent);

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
    // Show snack bar
    showSnackBarSuccess(context);

    // Start cool down for send button
    startCoolDownSendButton();

    // Send message to Firestore
    sendMessage(stringContent);
  }

  void showSnackBarSuccess(BuildContext context) {
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
  }

  Future<void> sendMessage(String content) async {
    try {
      await _sendMessageUseCase.execute(
        request: SendMessageParam(
          participants: _listMessageController.chatSessionParticipants,
          sender: _listMessageController.myFCMToken,
          content: content,
          timestamp: DateTime.now(),
        ),
      );
    } on AppException catch (e) {
      Logs.e("_sendMessageUseCase failed with $e");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  void startCoolDownSendButton() {
    state.isSendButtonWaiting.value = true;
    state.sendButtonText.value = R.strings.wait.tr;
    const coolDown = Duration(seconds: sendButtonCoolDownSecond);
    Timer(coolDown, () {
      state.isSendButtonWaiting.value = false;
      state.sendButtonText.value = R.strings.send.tr;
    });
  }

  void onFieldChange() {
    state.isTextFieldEmpty.value = mainTextEC.text.trim().isEmpty;
  }

  void onShortcutSelected(BuildContext context, bool selected, int index) {
    // Last item will open bottom sheet
    if (index == state.shortcutContents.toList().length - 1) {
      ShortcutBottomSheetView.openBottomSheet(context);
      return;
    }

    state.shortcutSelectedIndex.value = selected ? index : null;

    if (state.shortcutSelectedIndex.value != null) {
      mainTextEC.text = state.shortcutContents.toList()[index];
    } else {
      mainTextEC.clear();
    }
  }

  void onReplyMessage(BuildContext context) {
    FocusScope.of(context).requestFocus(mainTextFocusNode);
  }
}
