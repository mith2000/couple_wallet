part of 'list_message_controller.dart';

const emptyImageSize = 300.0;
const emptyWidgetWidthRatio = 0.66;
const emptyTextPositionX = emptyImageSize * 4 / 5;
const placeHolderCount = 8;

class ListMessageWidget extends GetView<ListMessageController> {
  const ListMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ShimmerLoader(
        loadData: controller.onInitFetchMessages,
        buildPlaceholder: () => buildPlaceholders(context),
        baseColor: AppColors.of.disableColor,
        buildContent: (data) => Obx(
          () {
            final listMessages = controller.messages.toList().sortByTime();
            if (listMessages.isEmpty) {
              return emptyWidget(context);
            }
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
                final isShow = listMessages[index + 1].isOwner != listMessages[index].isOwner;
                return LoveMessageWidget(
                  model: listMessages[index],
                  isShowPartnerAvatar: isShow,
                  onReply: () => controller.onReplyMessage(context),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget emptyWidget(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return Center(
      child: SizedBox(
        width: screenWidth * emptyWidgetWidthRatio,
        child: Stack(
          children: [
            R.pngs.appEmpty.image(
              height: emptyImageSize,
              width: emptyImageSize,
            ),
            Positioned.fill(
              top: emptyTextPositionX,
              child: Text(
                R.strings.createMemoryWithPartner.tr,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.of.mainTextColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceholders(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: placeHolderCount,
      separatorBuilder: (context, index) => Gap(AppThemeExt.of.dimen(4)),
      itemBuilder: (context, index) {
        final placeHolderWidth = screenWidth * messageBoxWidthRatio - AppThemeExt.of.dimen(4);
        if (index == 0 || index == 1 || index == 5 || index == 6) {
          return ChatMessagePlaceholder(
            perLineHeight: messageAvatarSize,
            horizontalPadding: 0,
            width: placeHolderWidth,
            isOwner: true,
          );
        }
        return ChatMessagePlaceholder(
          perLineHeight: messageAvatarSize,
          horizontalPadding: 0,
          width: placeHolderWidth,
        );
      },
    );
  }
}
