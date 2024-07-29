import 'package:get/get.dart';

import '../../domain/domain.dart';
import '../../resources/resources.dart';
import '../services/app_locale_service.dart';

class LoveMessageModelV {
  final String message;
  final bool isOwner;
  final DateTime time;

  LoveMessageModelV.me({
    required this.message,
    required this.time,
  }) : isOwner = true;

  LoveMessageModelV.opponent({
    required this.message,
    required this.time,
  }) : isOwner = false;

  String getTimeDisplay() {
    final dateDisplayService = Get.find<DateDisplayService>();
    final result = dateDisplayService.getDisplayDate(time, locale: AppLocaleService().localeString);
    if (result == todayKey) return R.strings.today.tr;
    if (result == yesterdayKey) return R.strings.yesterday.tr;
    return result;
  }
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
