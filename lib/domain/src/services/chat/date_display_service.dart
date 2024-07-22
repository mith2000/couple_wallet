import 'package:couple_wallet/utilities/date_time_util.dart';

const todayKey = 'today';
const yesterdayKey = 'yesterday';

abstract class DateDisplayService {
  bool isDisplayDate(DateTime previousItemDate, DateTime currentItemDate);

  String getDisplayDate(DateTime date, {String? locale});
}

class DateDisplayServiceImpl extends DateDisplayService {
  /// Input: [previousItemDate] and [currentItemDate]
  ///
  /// Output: [isDisplayDate] as boolean
  ///
  /// Business Logic: Messages with the same date will only shown the date once at the first message of the day
  @override
  bool isDisplayDate(DateTime previousItemDate, DateTime currentItemDate) {
    final startOfPreviousItemDate = previousItemDate.startOfDay;
    final startOfCurrentItemDate = currentItemDate.startOfDay;
    return startOfCurrentItemDate != startOfPreviousItemDate;
  }

  /// Input: The [date] to be displayed and the [locale] to be used if have
  ///
  /// Output: The date as String to be displayed
  ///
  /// Business Logic:
  /// if the date is Today, return 'Today';
  /// if it is Yesterday, return 'Yesterday';
  /// if it is in the same week as current week, return the date in the format of 'EEE HH:mm';
  /// else return the date in the format of 'MMM dd, HH:mm'
  @override
  String getDisplayDate(DateTime date, {String? locale}) {
    if (date.isToday) {
      return todayKey;
    }
    if (date.isYesterday) {
      return yesterdayKey;
    }
    return DateTimeUtil.toDateDisplay(
      dateTime: date,
      pattern: date.isTheSameWeek(DateTime.now())
          ? DateTimeUtil.patterneeeHHmm
          : DateTimeUtil.patternMMMddHHmm,
      locale: locale,
    );
  }
}
