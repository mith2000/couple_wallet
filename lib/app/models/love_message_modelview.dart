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
