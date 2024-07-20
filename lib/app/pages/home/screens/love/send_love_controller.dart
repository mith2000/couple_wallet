import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../domain/domain.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utilities/logs.dart';
import '../../../../../utilities/messaging_service.dart';
import '../../../../adapters/love_info_adapter.dart';
import '../../../../components/feature/home/home_app_bar.dart';
import '../../../../components/feature/home/home_heart_icon.dart';
import '../../../../components/feature/love/send_love_input.dart';
import '../../../../components/feature/shortcut/bottomSheet/shortcut_bottom_sheet_controller.dart';
import '../../../../components/main/dialogs/app_base_dialog.dart';
import '../../../../components/main/snackBars/app_base_snack_bar.dart';
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

  final GetLoveInfoUseCase getLoveInfoUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final ShortcutBottomSheetController shortcutBottomSheetController;
  final ListMessageController listMessageController;

  final TextEditingController mainTextEC = TextEditingController();
  final FocusNode mainTextFocusNode = FocusNode();

  SendLoveController({
    required this.getLoveInfoUseCase,
    required this.sendMessageUseCase,
    required this.shortcutBottomSheetController,
    required this.listMessageController,
  });

  @override
  void onInit() async {
    await getLoveInfo();
    super.onInit();
    initShortcut();

    mainTextEC.addListener(onFieldChange);
  }

  @override
  void onClose() {
    super.onClose();
    mainTextEC.dispose();
    mainTextFocusNode.dispose();
  }

  Future<void> getLoveInfo() async {
    final response = await getLoveInfoUseCase();
    final model = response.netData;
    if (model != null) {
      ILoveInfoAdapter loveInfoAdapter = LoveInfoAdapter();
      state.loveInfo.value = loveInfoAdapter.getModelView(model);
    }
  }

  void initShortcut() {
    state.shortcutContents.value = shortcutBottomSheetController.shortcutContents;
  }

  void onSendButtonClicked(BuildContext context) {
    // Get string content (before clear text field)
    final stringContent = mainTextEC.text.trim();

    clearInput();

    String partnerAddress = listMessageController.partnerFCMToken;
    if (partnerAddress.isNotEmpty) {
      onSendNotification(partnerAddress, stringContent, context);
    } else {
      onNoPartnerAddressFound(context);
    }
  }

  void clearInput() {
    // Clear & Un-focus to off the keyboard
    mainTextEC.clear();
    state.shortcutSelectedIndex.value = null;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onNoPartnerAddressFound(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    AppDefaultDialog(
      contentWidgets: [Text(R.strings.checkPartnerAddress.tr)],
      onPrimaryPressed: () => Get.find<HomeController>().goSetting(),
    ).show(context);
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
    // Show snack bar
    showSnackBarSuccess(context);

    // Start cool down for send button
    startCoolDownSendButton();

    // Send message to Firestore
    sendMessageToFirestore(stringContent);
  }

  void showSnackBarSuccess(BuildContext context) {
    AppDefaultSnackBar(
      context: context,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(R.strings.wordsOfLoveHaveBeenSent.tr)),
          Lottie.asset(
            R.json.animCheck.path,
            width: snackBarIconSize,
            height: snackBarIconSize,
            repeat: false,
          ),
        ],
      ),
    ).show();
  }

  Future<void> sendMessageToFirestore(String content) async {
    try {
      await sendMessageUseCase(
        request: SendMessageParam(
          participants: listMessageController.chatSessionParticipants,
          sender: listMessageController.myFCMToken,
          content: content,
          timestamp: DateTime.now(),
        ),
      );
      // Add message to UI list
      listMessageController.addMessageToListAsOwner(content);
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
