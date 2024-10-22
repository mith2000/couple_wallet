import '../../../domain/domain.dart';
import '../sources/local/base_local_data_source.dart';

class SharedPrefRepositoryImpl extends SharedPrefRepository {
  late final SharedPrefLocalDataSource _sharedPrefDS;

  SharedPrefRepositoryImpl(this._sharedPrefDS);

  @override
  Future<String> getUserID() => _sharedPrefDS.getUserID();

  @override
  Future<void> saveUserID(String id) => _sharedPrefDS.saveUserID(id);

  @override
  Future<String?> getUserFCMToken() => _sharedPrefDS.getUserFCMToken();

  @override
  Future<void> saveUserFCMToken(String token) =>
      _sharedPrefDS.saveUserFCMToken(token);

  @override
  Future<String> getPartnerFCMToken() => _sharedPrefDS.getPartnerFCMToken();

  @override
  Future<void> savePartnerFCMToken(String token) =>
      _sharedPrefDS.savePartnerFCMToken(token);
}
