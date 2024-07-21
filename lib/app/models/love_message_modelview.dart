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

  String get timeDisplay => DateTimeUtil.toDateDisplay(
        dateTime: time,
        pattern: DateTimeUtil.patterneeeHHmm,
        locale: AppLocaleService().localeString,
      );
}

extension ListOfLoveMessageModelV on List<LoveMessageModelV> {
  List<LoveMessageModelV> sortByTime() {
    final now = DateTime.now();
    sort((a, b) {
      final diffA = a.time.difference(now).abs();
      final diffB = b.time.difference(now).abs();
      return diffA.compareTo(diffB);
    });
    return this;
  }
}
