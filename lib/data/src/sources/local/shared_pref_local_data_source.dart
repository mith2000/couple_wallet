part of 'base_local_data_source.dart';

abstract class SharedPrefLocalDataSource {
  Future<String> getUserID();

  Future<void> saveUserID(String id);

  Future<String?> getUserFCMToken();

  Future<void> saveUserFCMToken(String token);

  Future<String> getPartnerFCMToken();

  Future<void> savePartnerFCMToken(String token);
}

class SharedPrefLocalDataSourceImpl extends SharedPrefLocalDataSource {
  final AppSharedPref _sharedPref;

  SharedPrefLocalDataSourceImpl(this._sharedPref);

  @override
  Future<String> getUserID() async {
    String userID = _sharedPref.getString(AppPrefKey.appUUID, '');
    return userID;
  }

  @override
  Future<void> saveUserID(String id) async {
    try {
      await _sharedPref.setString(AppPrefKey.appUUID, id);
    } catch (e) {
      LocalExceptionLogs.onError(e);
      throw LocalHandleError.unknown(e);
    }
  }

  @override
  Future<String?> getUserFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      LocalExceptionLogs.onError(e);
      throw LocalHandleError.unknown(e);
    }
  }

  @override
  Future<void> saveUserFCMToken(String token) async {
    try {
      await _sharedPref.setString(AppPrefKey.userAddress, token);
    } catch (e) {
      LocalExceptionLogs.onError(e);
      throw LocalHandleError.unknown(e);
    }
  }

  @override
  Future<String> getPartnerFCMToken() async {
    String partnerAddress = _sharedPref.getString(AppPrefKey.partnerAddress, '');
    return partnerAddress;
  }

  @override
  Future<void> savePartnerFCMToken(String token) async {
    try {
      await _sharedPref.setString(AppPrefKey.partnerAddress, token);
    } catch (e) {
      LocalExceptionLogs.onError(e);
      throw LocalHandleError.unknown(e);
    }
  }
}
