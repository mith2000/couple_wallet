part of 'list_message_controller.dart';

class ListMessageWidget extends GetView<ListMessageController> {
  const ListMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
