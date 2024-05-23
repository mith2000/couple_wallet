part of 'send_love_controller.dart';

const backgroundColor = Color(0xffFCF1DE);

class SendLoveScreen extends GetView<SendLoveController> {
  const SendLoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppThemeExt.of.dimen(4)),
      child: Column(
        children: [
          Expanded(child: Container()),
          FormBuilder(
            key: controller.formKey,
            child: Obx(
              () => SendLoveInput(
                textEditingController: controller.textEditingController,
                fieldName: mainTextFieldName,
                onSubmit: () => controller.onSubmit(context),
                onFieldChange: controller.onFieldChange,
                isShowSendButton: controller.isTextFieldEmpty.isFalse,
                isSendButtonWaiting: controller.isSendButtonWaiting.isTrue,
                sendButtonText: controller.sendButtonText.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
