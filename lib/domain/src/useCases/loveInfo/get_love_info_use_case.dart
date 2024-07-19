part of '../base_use_case.dart';

abstract class GetLoveInfoUseCase
    extends BaseUseCase<BaseParam, LoveInfoModel> {}

class GetLoveInfoUseCaseImpl extends GetLoveInfoUseCase {
  // Remove this hardcode and get from user input
  final DateTime loveStartDate = DateTime(2022, 11, 13);

  @override
  Future<AppResultModel<LoveInfoModel>> call({BaseParam? request}) async {
    final now = DateTime.now().startOfDay();
    final daysInDifference = now.difference(loveStartDate).inDays;
    final model = LoveInfoModel(totalLoveDays: daysInDifference);
    return AppResultModel<LoveInfoModel>(netData: model);
  }
}
