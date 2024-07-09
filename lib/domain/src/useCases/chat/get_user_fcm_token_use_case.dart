part of '../base_use_case.dart';

abstract class GetUserFcmTokenUseCase extends BaseUseCase<BaseParam, SimpleModel<String?>> {}

class GetUserFcmTokenUseCaseImpl extends GetUserFcmTokenUseCase {
  final SharedPrefRepository _repository;

  GetUserFcmTokenUseCaseImpl(this._repository);

  @override
  Future<AppResultModel<SimpleModel<String?>>> execute({BaseParam? request}) async {
    final response = await _repository.getUserFCMToken();
    return AppResultModel<SimpleModel<String?>>(netData: SimpleModel(response));
  }
}
