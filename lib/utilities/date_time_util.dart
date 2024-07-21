import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  const DateTimeUtil._();

  static const String localeEnglish = 'en_US';
  static const String emptyDateDisplay = '--/--/----';
  static const String emptyDateRangeDisplay = '--/--/---- - --/--/----';
  static const String emptyTimeDisplay = '--:--';
  static const String patternddMMyyyy = 'dd/MM/yyyy';
  static const String patternHHmm = 'HH:mm';
  static const String patterneeeHHmm = 'EEE HH:mm';

  static String toDateDisplay({
    required DateTime? dateTime,
    String pattern = patternddMMyyyy,
    String? locale = localeEnglish,
  }) {
    return dateTime != null ? DateFormat(pattern, locale).format(dateTime) : emptyDateDisplay;
  }

  static String toTimeDisplay({
    required DateTime? dateTime,
    String pattern = patternHHmm,
    String? locale = localeEnglish,
  }) {
    return dateTime != null ? DateFormat(pattern, locale).format(dateTime) : emptyTimeDisplay;
  }

  static String toDateRangeDisplay({
    required DateTimeRange? dateTimeRange,
    String pattern = patternddMMyyyy,
    String? locale = localeEnglish,
  }) {
    return dateTimeRange != null
        ? '${toDateDisplay(
            dateTime: dateTimeRange.start,
            pattern: pattern,
            locale: locale,
          )} - ${toDateDisplay(
            dateTime: dateTimeRange.end,
            pattern: pattern,
            locale: locale,
          )}'
        : emptyDateRangeDisplay;
  }

  static DateTime? fromString({required String? date}) {
    return date != null ? DateTime.tryParse(date) : null;
  }

  static DateTime fromTimeStamp(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.addDays(i));
    }
    return days;
  }
}

extension DateTimeExt on DateTime {
  DateTime addDays(int days) => add(Duration(days: days));

  DateTime subtractDays(int days) => subtract(Duration(days: days));

  bool isTheSameDate(DateTime other) {
    return isTheSameMonth(other) && day == other.day;
  }

  bool isTheSameMonth(DateTime other) {
    return isTheSameYear(other) && month == other.month;
  }

  bool isTheSameYear(DateTime other) {
    return year == other.year;
  }

  bool get isToday => isTheSameDate(DateTime.now());

  bool isMoreThanInMinute(DateTime other, int minutes) {
    return difference(other).inMinutes > minutes;
  }

  DateTime get startOfDay => DateTime(year, month, day, 0, 0, 0);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  bool get isInThePast => DateTime.now().isAfter(this);

  int get totalDaysFromNow => startOfDay.difference(DateTime.now().startOfDay).inDays;
}
