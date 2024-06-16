part of 'base_param.dart';

class ChatQueryParam extends BaseParam {
  final List<String> participants;

  ChatQueryParam({required this.participants});

  Map<String, dynamic> toJson() {
    return MapJson.removeJsonIfNull({
      'participants': participants,
    });
  }
}
