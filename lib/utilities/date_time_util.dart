import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeExt {
  const DateTimeExt._();

  static const int weekStartDay = DateTime.saturday;

  static const String ddMMyyyy = 'dd/MM/yyyy';
  static const String HHmm = 'HH:mm';
  static const String eeeHHmm = 'EEE HH:mm';
  static const String MMMdHHmm = 'MMM d HH:mm';

  static String dateTimeToDisplay({
    required DateTime? dateTime,
    String pattern = ddMMyyyy,
    String? locale = 'en_US',
  }) {
    return dateTime != null
        ? DateFormat(pattern, locale).format(dateTime)
        : '--/--/----';
  }

  static int getDaysRemaining({required DateTime? dateTime}) {
    if (dateTime == null) {
      return 0;
    }

    DateTime currentDate = DateTime.now().toLocal().toUtc().subtract(Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
        milliseconds: DateTime.now().millisecond,
        microseconds: DateTime.now().microsecond));

    DateTime inputDate = dateTime.toLocal().toUtc().subtract(Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
        milliseconds: dateTime.millisecond,
        microseconds: dateTime.microsecond));
    int daysDifference = inputDate.difference(currentDate).inDays;
    return inputDate.isAtSameMomentAs(currentDate) ? 0 : daysDifference;
  }

  static String timeToDisplay(
      {required DateTime? dateTime, String pattern = HHmm}) {
    return dateTime != null ? DateFormat(pattern).format(dateTime) : '--:--';
  }

  static String dateTimeRangeToDisplay(
      {required DateTimeRange? dateTimeRange, String pattern = ddMMyyyy}) {
    return dateTimeRange != null
        ? '${dateTimeToDisplay(dateTime: dateTimeRange.start, pattern: pattern)} - ${dateTimeToDisplay(dateTime: dateTimeRange.end, pattern: pattern)}'
        : '--/--/---- - --/--/----';
  }

  static String customFormatDateTimeRangeToDisplay(
      {required DateTimeRange? dateTimeRange, String pattern = ddMMyyyy}) {
    return dateTimeRange != null
        ? '${dateTimeToDisplay(dateTime: dateTimeRange.start, pattern: pattern)}\u3164→\u3164${dateTimeToDisplay(dateTime: dateTimeRange.end, pattern: pattern)}'
        : '--/--/----\u3164→\u3164--/--/----';
  }

  static DateTime? stringToDate({required String? date}) {
    return date != null ? DateTime.tryParse(date) : null;
  }

  static DateTime convertTimeStampToDateTime(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.addExt(i));
    }
    return days;
  }
}

extension AppDateTime on DateTime {
  DateTime addExt(int days) => add(Duration(days: days));

  DateTime subtractExt(int days) => subtract(Duration(days: days));

  bool isTheSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isTheSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool get isToday => isTheSameDate(DateTime.now());

  bool isMoreThanInMinute(DateTime other, int minutes) {
    return difference(other).inMinutes > minutes;
  }

  DateTime startOfDay() {
    return DateTime(year, month, day, 0, 0, 0);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  bool isInPast({int days = 0}) {
    return DateTime.now().subtractExt(days).isAfter(this);
  }

  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return difference.inMinutes > 1
          ? '${difference.inMinutes} minutes'
          : '1 minute';
    } else if (difference.inHours < 24) {
      return difference.inHours > 1 ? '${difference.inHours} hours' : '1 hour';
    } else {
      return difference.inDays > 1 ? '${difference.inDays} days' : '1 day';
    }
  }
}
