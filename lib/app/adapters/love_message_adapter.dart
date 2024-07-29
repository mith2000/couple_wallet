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
      final messageTime = message.timestamp.toLocal();
      result.add(
        message.sender == ownerId
            ? LoveMessageModelV.me(
                message: message.content,
                time: messageTime,
              )
            : LoveMessageModelV.opponent(
                message: message.content,
                time: messageTime,
              ),
      );
    }
    return result;
  }
}
