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
        pattern: DateTimeExt.eeeHHmm,
        locale: AppLocaleService().localeString,
      );
}
