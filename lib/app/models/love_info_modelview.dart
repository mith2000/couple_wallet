class LoveInfoModelView {
  final int totalLoveDays;

  LoveInfoModelView({
    required this.totalLoveDays,
  });

  String get totalLoveDaysDisplay => totalLoveDays.toString();
}
