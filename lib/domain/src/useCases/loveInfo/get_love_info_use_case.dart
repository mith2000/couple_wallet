part of '../base_use_case.dart';

abstract class GetLoveInfoUseCase
    extends BaseUseCase<BaseParam, LoveInfoModel> {}

class GetLoveInfoUseCaseImpl extends GetLoveInfoUseCase {
  // Remove this hardcode and get from user input
  final DateTime loveStartDate = DateTime(2022, 11, 13);

  @override
  Future<AppResultModel<LoveInfoModel>> call({BaseParam? request}) async {
    final model = LoveInfoModel(totalLoveDays: loveStartDate.totalDaysFromNow);
    return AppResultModel<LoveInfoModel>(netData: model);
  }
}
