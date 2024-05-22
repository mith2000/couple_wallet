import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../resources/resources.dart';
import '../../../../components/feature/love/send_love_input.dart';
import '../../../../theme/app_theme.dart';

part 'send_love_screen.dart';

const mainTextFieldName = 'main';
const sendButtonCoolDownSecond = 60;

class SendLoveController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController textEditingController = TextEditingController();

  // If text field is empty => Hide the Send button
  final RxBool isTextFieldEmpty = true.obs;

  // If send button is waiting for cool down
  final RxBool isSendButtonWaiting = false.obs;

  // Send button text base on its state
  final RxString sendButtonText = RxString(R.strings.send.tr);

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
    // Save & validate the form
    if (formKey.currentState?.saveAndValidate() == false) return;

    // Start cool down for send button
    startCoolDownSendButton();

    // Get string content
    final stringContent =
        (formKey.currentState?.fields[mainTextFieldName]?.value ?? '')
            .toString()
            .trim();

    // Clear & Un-focus to off the keyboard
    textEditingController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

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
  }

  void onFieldChange(String? value) {
    if (value == null || value.trim().isEmpty) {
      isTextFieldEmpty.value = true;
    } else {
      isTextFieldEmpty.value = false;
    }
  }
}
