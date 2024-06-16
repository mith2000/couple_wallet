part of 'base_param.dart';

class SendMessageParam extends BaseParam {
  final List<String> participants;
  final String id;
  final String sender;
  final String content;
  final DateTime timestamp;

  SendMessageParam({
    required this.participants,
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return MapJson.removeJsonIfNull({
      // no need to send 'participants'
      'id': id,
      'sender': sender,
      'content': content,
      'timestamp': DateTimeModelFormatter.toJson(timestamp),
    });
  }
}
