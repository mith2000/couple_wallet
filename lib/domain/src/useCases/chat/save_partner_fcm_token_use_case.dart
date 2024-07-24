part of '../base_use_case.dart';

abstract class SavePartnerFcmTokenUseCase extends BaseUseCase<SimpleParam<String>, EmptyModel> {}

class SavePartnerFcmTokenUseCaseImpl extends SavePartnerFcmTokenUseCase {
  final SharedPrefRepository _repository;

  SavePartnerFcmTokenUseCaseImpl(this._repository);

  @override
  Future<AppResultModel<EmptyModel>> call({SimpleParam<String>? request}) async {
    final requestParam = request;
    if (requestParam == null || requestParam.value.isEmpty) {
      throw LocalException(
        code: ErrorCode.code400,
        message: 'Lack of input',
        errorCode: ErrorCode.lackOfInputError,
      );
    }
    await _repository.savePartnerFCMToken(requestParam.value);
    return AppResultModel(netData: EmptyModel());
  }
}
