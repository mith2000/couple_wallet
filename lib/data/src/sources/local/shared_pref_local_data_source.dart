part of 'base_local_data_source.dart';

abstract class SharedPrefLocalDataSource {
  Future<String?> getUserFCMToken();

  Future<void> saveUserFCMToken(String token);

  Future<String> getPartnerFCMToken();

  Future<void> savePartnerFCMToken(String token);
}

class SharedPrefLocalDataSourceImpl extends SharedPrefLocalDataSource {
  final AppSharedPref _sharedPref;

  SharedPrefLocalDataSourceImpl(this._sharedPref);

  @override
  Future<String?> getUserFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      LocalExceptionLogs.onError(e);
      throw LocalException(
        code: ErrorCode.code9999,
        message: 'Something went wrong: ${e.toString()}',
        errorCode: ErrorCode.unknownLocalServiceError,
      );
    }
  }

  @override
  Future<void> saveUserFCMToken(String token) async {
    try {
      await _sharedPref.setString(AppPrefKey.userAddress, token);
    } catch (e) {
      LocalExceptionLogs.onError(e);
      throw LocalException(
        code: ErrorCode.code9999,
        message: 'Something went wrong: ${e.toString()}',
        errorCode: ErrorCode.unknownLocalServiceError,
      );
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
      throw LocalException(
        code: ErrorCode.code9999,
        message: 'Something went wrong: ${e.toString()}',
        errorCode: ErrorCode.unknownLocalServiceError,
      );
    }
  }
}
