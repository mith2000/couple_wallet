part of 'base_repository.dart';

abstract class SharedPrefRepository {
  Future<String?> getUserFCMToken();

  Future<void> saveUserFCMToken(String token);

  Future<String> getPartnerFCMToken();

  Future<void> savePartnerFCMToken(String token);
}
