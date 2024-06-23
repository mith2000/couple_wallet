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
            Expanded(
              child: Obx(
                () {
                  final listMessages = LoveMessageModelV.sortMessagesByTime(
                      controller.messages.toList());
                  return ListView.builder(
                    itemCount: listMessages.length,
                    itemBuilder: (context, index) {
                      // The last one should show the partner's avatar if owner is false
                      if (index == listMessages.length - 1) {
                        return LoveMessageWidget(
                          model: listMessages[index],
                          isShowPartnerAvatar: true,
                          onReply: () => controller.onReplyMessage(context),
                        );
                      }
                      // If the next one is not same owner, show the partner's avatar
                      return LoveMessageWidget(
                        model: listMessages[index],
                        isShowPartnerAvatar: listMessages[index + 1].isOwner !=
                            listMessages[index].isOwner,
                        onReply: () => controller.onReplyMessage(context),
                      );
                    },
                  );
                },
              ),
            ),
            _buildShortcuts(context),
            Gap(AppThemeExt.of.dimen(2)),
            Obx(
              () => SendLoveInput(
                textEditingController: controller.mainTextEC,
                focusNode: controller.mainTextFocusNode,
                onSubmit: () => controller.onSubmit(context),
                isShowSendButton: controller.isTextFieldEmpty.isFalse,
                isSendButtonWaiting: controller.isSendButtonWaiting.isTrue,
                sendButtonText: controller.sendButtonText.value,
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
              child: Text(
                controller.countLoveDays(),
                style: context.textTheme.bodyMedium!.copyWith(
                  color: backgroundColor,
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
