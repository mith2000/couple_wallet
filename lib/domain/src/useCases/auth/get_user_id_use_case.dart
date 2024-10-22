part of '../base_use_case.dart';

abstract class GetUserIDUseCase
    extends BaseUseCase<BaseParam, SimpleModel<String>> {}

class GetUserIDUseCaseImpl extends GetUserIDUseCase {
  final SharedPrefRepository _repository;
  final SaveUserIDUseCase saveUserIDUseCase;

  GetUserIDUseCaseImpl(this._repository, {required this.saveUserIDUseCase});

  @override
  Future<AppResultModel<SimpleModel<String>>> call({BaseParam? request}) async {
    String userId = await _repository.getUserID();
    // First time enter the app
    if (userId.isEmpty) {
      userId = generateUUID();
      await saveUserID(userId);
    }
    return AppResultModel<SimpleModel<String>>(netData: SimpleModel(userId));
  }

  Future<void> saveUserID(String userID) async {
    try {
      await saveUserIDUseCase(request: SimpleParam(userID));
    } on AppException catch (e) {
      Logs.e("saveUserID failed with ${e.toString()}");
      rethrow;
    }
  }

  String generateUUID() {
    final result = UUIDGenerator.generate();
    Logs.i("Generated UUID: $result");
    return result;
  }
}
