import '../../domain/domain.dart';

class LoveInfoModelView {
  final int totalLoveDays;

  LoveInfoModelView({
    required this.totalLoveDays,
  });

  static fromLoveInfoModel(LoveInfoModel model) {
    return LoveInfoModelView(totalLoveDays: model.totalLoveDays);
  }

  String get totalLoveDaysDisplay => totalLoveDays.toString();
}
