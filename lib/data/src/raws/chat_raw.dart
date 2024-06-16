part of 'base_raw.dart';

class ChatRaw extends BaseRaw<ChatModel> {
  final List<String>? participants;
  final List<MessageRaw>? messages;

  ChatRaw({
    this.participants,
    this.messages,
  });

  factory ChatRaw.fromJson(Map<String, dynamic> json) => ChatRaw(
        participants: (json['participants'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => MessageRaw.fromJson(e as Map<String, dynamic>?))
            .toList(),
      );

  factory ChatRaw.empty() => ChatRaw(
        participants: List.empty(),
        messages: List.empty(),
      );

  @override
  ChatModel raw2Model() {
    return ChatModel(
      participants: participants ?? List.empty(),
      messages: messages?.map((e) => e.raw2Model()).toList() ?? List.empty(),
    );
  }
}
