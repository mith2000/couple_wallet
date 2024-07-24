part of 'base_repository.dart';

abstract class UserRepository {
  Future<AppResultModel<UserModel>> getUserInfo({
    required String userId,
  });

  Future<AppResultModel<EmptyModel>> registerUser({
    required Map<String, dynamic> request,
  });
}
