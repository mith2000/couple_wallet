part of '../base_use_case.dart';

abstract class GetPartnerFcmTokenUseCase
    extends BaseUseCase<BaseParam, SimpleModel<String>> {}

class GetPartnerFcmTokenUseCaseImpl extends GetPartnerFcmTokenUseCase {
  final SharedPrefRepository _repository;

  GetPartnerFcmTokenUseCaseImpl(this._repository);

  @override
  Future<AppResultModel<SimpleModel<String>>> call({BaseParam? request}) async {
    final response = await _repository.getPartnerFCMToken();
    return AppResultModel<SimpleModel<String>>(netData: SimpleModel(response));
  }
}
