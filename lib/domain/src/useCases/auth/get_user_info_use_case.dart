part of '../base_use_case.dart';

abstract class GetUserInfoUseCase extends BaseUseCase<SimpleParam<String>, UserModel> {}

class GetUserInfoUseCaseImpl extends GetUserInfoUseCase {
  final UserRepository _repository;

  GetUserInfoUseCaseImpl(this._repository);

  @override
  Future<AppResultModel<UserModel>> call({SimpleParam<String>? request}) {
    final requestParam = request;
    if (requestParam == null || requestParam.value.isEmpty) {
      throw LocalException(
        code: ErrorCode.code400,
        message: 'Lack of input',
        errorCode: ErrorCode.lackOfInputError,
      );
    }
    return _repository.getUserInfo(userId: requestParam.value);
  }
}
