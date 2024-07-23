part of '../base_use_case.dart';

abstract class SaveUserIDUseCase extends BaseUseCase<SimpleParam<String>, EmptyModel> {}

class SaveUserIDUseCaseImpl extends SaveUserIDUseCase {
  final SharedPrefRepository _repository;

  SaveUserIDUseCaseImpl(this._repository);

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
    await _repository.saveUserID(requestParam.value);
    return AppResultModel(netData: EmptyModel());
  }
}
