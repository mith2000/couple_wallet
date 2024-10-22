import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

const localIconDir = '@mipmap/ic_launcher';

const _firebaseMessagingScope =
    "https://www.googleapis.com/auth/firebase.messaging";
const _serviceAccountPath = "serviceAccountKey.json";

final class FirebaseAccessTokenAPI {
  FirebaseAccessTokenAPI._();

  /// Cached instance of [FirebaseAccessTokenAPI];
  static FirebaseAccessTokenAPI? _instance;

  /// Returns an instance.
  static FirebaseAccessTokenAPI get instance {
    _instance ??= FirebaseAccessTokenAPI._();
    return _instance!;
  }

  String _accessToken = '';

  String get accessToken => _accessToken;

  Future<void> claimAccessToken() async {
    final serviceAccount = await rootBundle.loadString(_serviceAccountPath);
    final serviceAccountJSON = jsonDecode(serviceAccount);

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(serviceAccountJSON),
      [_firebaseMessagingScope],
    );

    // Extract the access token from the credentials
    _accessToken = client.credentials.accessToken.data;
  }
}
