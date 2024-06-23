part of 'base_model.dart';

class ChatModel extends BaseModel {
  final List<String> participants;
  final List<MessageModel> messages;

  ChatModel({
    required this.participants,
    required this.messages,
  });
}
