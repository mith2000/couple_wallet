part of 'base_repository.dart';

abstract class SharedPrefRepository {
  Future<String> getUserID();

  Future<void> saveUserID(String id);

  Future<String?> getUserFCMToken();

  Future<void> saveUserFCMToken(String token);

  Future<String> getPartnerFCMToken();

  Future<void> savePartnerFCMToken(String token);
}
