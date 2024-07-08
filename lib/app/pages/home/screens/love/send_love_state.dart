part of 'send_love_controller.dart';

class SendLoveState {
  // If text field is empty => Hide the Send button
  final RxBool isTextFieldEmpty = true.obs;

  // If send button is waiting for cool down
  final RxBool isSendButtonWaiting = false.obs;

  // Send button text base on its state
  final RxString sendButtonText = RxString(R.strings.send.tr);

  final RxnInt shortcutSelectedIndex = RxnInt();
}
