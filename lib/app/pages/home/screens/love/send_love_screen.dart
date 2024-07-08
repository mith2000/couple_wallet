part of 'send_love_controller.dart';

const backgroundColor = Color(0xffFCF1DE);

class SendLoveScreen extends GetView<SendLoveController> {
  const SendLoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        HomeAppBar(
          spaceWidget: _spaceWidget(context),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(AppThemeExt.of.dimen(4))
            .copyWith(top: 0, bottom: AppThemeExt.of.dimen(2)),
        child: Column(
          children: [
            const ListMessageWidget(),
            _buildShortcuts(context),
            Gap(AppThemeExt.of.dimen(2)),
            Obx(
              () => SendLoveInput(
                textEditingController: controller.mainTextEC,
                focusNode: controller.mainTextFocusNode,
                onSubmit: () => controller.onSubmit(context),
                isShowSendButton: controller.state.isTextFieldEmpty.isFalse,
                isSendButtonWaiting: controller.state.isSendButtonWaiting.isTrue,
                sendButtonText: controller.state.sendButtonText.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcuts(BuildContext context) {
    return Wrap(
      spacing: AppThemeExt.of.dimen(2),
      children: List.generate(
        controller.state.shortcutContents.toList().length,
        (int index) {
          return Obx(
            () => ChoiceChip(
              label: Text(
                controller.state.shortcutContents.toList()[index],
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: AppColors.of.mainTextColor,
                    ),
              ),
              showCheckmark: false,
              selected: controller.state.shortcutSelectedIndex.value == index,
              onSelected: (bool sel) => controller.onShortcutSelected(context, sel, index),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: controller.state.shortcutSelectedIndex.value == index
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

  Widget _spaceWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _avatar(),
        Stack(
          alignment: Alignment.center,
          children: [
            const HeartAnimation(size: heartSize),
            Positioned(
              top: heartSize * 1 / 3 + 2,
              child: Obx(
                () => Text(
                  controller.state.loveInfo.value?.totalLoveDaysDisplay ?? '--',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: backgroundColor,
                  ),
                ),
              ),
            )
          ],
        ),
        _avatar(),
      ],
    );
  }

  Widget _avatar() {
    return Container(
      height: avatarSize,
      width: avatarSize,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CircleAvatar(child: R.pngs.appIcon.image()),
    );
  }
}
