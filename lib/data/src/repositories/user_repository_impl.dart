import '../../../domain/domain.dart';
import '../raws/base_raw.dart';
import '../sources/firestore/base_firestore_data_source.dart';

class UserRepositoryImpl extends UserRepository {
  late final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<AppResultModel<UserModel>> getUserInfo({
    required String userId,
  }) async {
    try {
      final AppResultRaw<UserRaw> remoteData =
          await _remoteDataSource.getUserInfo(
        userId: userId,
      );

      return remoteData.raw2Model();
    } on NetworkException catch (_) {
      rethrow;
    }
  }

  @override
  Future<AppResultModel<EmptyModel>> registerUser({
    required Map<String, dynamic> request,
  }) async {
    try {
      final AppResultRaw<EmptyRaw> remoteData =
          await _remoteDataSource.registerUser(
        request: request,
      );

      return remoteData.raw2Model();
    } on NetworkException catch (_) {
      rethrow;
    }
  }
}
