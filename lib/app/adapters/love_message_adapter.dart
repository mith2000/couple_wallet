import '../../domain/domain.dart';
import '../models/love_message_modelview.dart';

abstract class ILoveMessageAdapter {
  List<LoveMessageModelV> getListModelView(
    ChatModel model,
    String ownerId,
  );
}

class LoveMessageAdapter implements ILoveMessageAdapter {
  @override
  List<LoveMessageModelV> getListModelView(
    ChatModel model,
    String ownerId,
  ) {
    if (!model.participants.contains(ownerId)) return [];
    List<LoveMessageModelV> result = [];
    for (MessageModel message in model.messages) {
      result.add(
        LoveMessageModelV(
          message: message.content,
          isOwner: message.sender == ownerId,
          time: message.timestamp.toLocal(),
        ),
      );
    }
    return result;
  }
}
