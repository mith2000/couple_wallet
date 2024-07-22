import 'package:couple_wallet/utilities/date_time_util.dart';

abstract class DateDisplayService {
  bool isDisplayDate(DateTime previousItemDate, DateTime currentItemDate);
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
}
