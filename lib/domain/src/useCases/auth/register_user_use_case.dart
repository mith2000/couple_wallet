part of '../base_use_case.dart';

abstract class RegisterUserUseCase
    extends BaseUseCase<RegisterUserParam, EmptyModel> {}

class RegisterUserUseCaseImpl extends RegisterUserUseCase {
  final UserRepository _repository;

  RegisterUserUseCaseImpl(this._repository);

  @override
  Future<AppResultModel<EmptyModel>> call({RegisterUserParam? request}) {
    final requestParam = request;
    if (requestParam == null) {
      throw LocalException(
        code: ErrorCode.code400,
        message: 'Lack of input',
        errorCode: ErrorCode.lackOfInputError,
      );
    }
    return _repository.registerUser(request: requestParam.toJson());
  }
}
