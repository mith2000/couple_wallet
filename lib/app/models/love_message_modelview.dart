import '../../domain/domain.dart';
import '../../utilities/date_time_util.dart';
import '../services/app_locale_service.dart';

class LoveMessageModelV {
  final String message;
  final bool isOwner;
  final DateTime time;

  LoveMessageModelV({
    required this.message,
    required this.isOwner,
    required this.time,
  });

  String get timeDisplay => DateTimeExt.dateTimeToDisplay(
        dateTime: time,
        pattern: DateTimeExt.patterneeeHHmm,
        locale: AppLocaleService().localeString,
      );

  static List<LoveMessageModelV> fromChatModel(
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

  static List<LoveMessageModelV> sortMessagesByTime(
      List<LoveMessageModelV> messages) {
    final now = DateTime.now();
    messages.sort((a, b) {
      final diffA = a.time.difference(now).abs();
      final diffB = b.time.difference(now).abs();
      return diffA.compareTo(diffB);
    });
    return messages;
  }
}
