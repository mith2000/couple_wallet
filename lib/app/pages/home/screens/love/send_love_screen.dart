part of 'send_love_controller.dart';

const backgroundColor = Color(0xffFCF1DE);

class SendLoveScreen extends GetView<SendLoveController> {
  const SendLoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppThemeExt.of.dimen(4))
          .copyWith(top: 0, bottom: AppThemeExt.of.dimen(2)),
      child: Column(
        children: [
          Expanded(child: Container()),
          _buildShortcuts(context),
          Gap(AppThemeExt.of.dimen(2)),
          FormBuilder(
            key: controller.formKey,
            child: Obx(
              () => SendLoveInput(
                textEditingController: controller.mainTextEC,
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

  Widget _buildShortcuts(BuildContext context) {
    return Wrap(
      spacing: AppThemeExt.of.dimen(2),
      children: List.generate(
        controller.shortcutContent.length,
        (int index) {
          return Obx(
            () => ChoiceChip(
              label: Text(
                controller.shortcutContent[index],
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.of.mainTextColor,
                    ),
              ),
              showCheckmark: false,
              selected: controller.shortcutSelectedIndex.value == index,
              onSelected: (bool sel) =>
                  controller.onShortcutSelected(context, sel, index),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: controller.shortcutSelectedIndex.value == index
                      ? Theme.of(context).primaryColor
                      : AppColors.of.borderColor,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
