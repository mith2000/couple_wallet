part of 'base_raw.dart';

class MessageRaw extends BaseRaw<MessageModel> {
  final String? id;
  final String? sender;
  final String? content;
  final DateTime? timestamp;

  MessageRaw({
    this.id,
    this.sender,
    this.content,
    this.timestamp,
  });

  factory MessageRaw.fromJson(Map<String, dynamic>? json) => MessageRaw(
        id: json?['id'] as String?,
        sender: json?['sender'] as String?,
        content: json?['content'] as String?,
        timestamp: DateTimeModelFormatter.fromJson(json?['timestamp']),
      );

  static List<MessageRaw> fromJsonToList(List<dynamic>? json) {
    return json?.map((e) => MessageRaw.fromJson(e)).toList() ?? List.empty();
  }

  @override
  MessageModel raw2Model() {
    return MessageModel(
      id: id ?? '',
      sender: sender ?? '',
      content: content ?? '',
      timestamp: timestamp ?? DateTime.now(),
    );
  }
}
