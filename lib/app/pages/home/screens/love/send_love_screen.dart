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
            Gap(AppThemeExt.of.dimen(1)),
            Obx(
              () => SendLoveInput(
                textEditingController: controller.mainTextEC,
                focusNode: controller.mainTextFocusNode,
                onSubmit: () => controller.onSendButtonClicked(context),
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
    return Obx(
      () => ShortcutListHome(
        shortcutContents: controller.state.shortcutContents.toList(),
        shortcutSelectedIndex: controller.state.shortcutSelectedIndex.value,
        onSelected: controller.onShortcutSelected,
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
