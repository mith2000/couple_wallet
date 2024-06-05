import 'dart:convert';

import 'package:couple_wallet/utilities/logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseMessagingAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Init notification
  Future<void> initNotification() async {
    // request permission (nothing happen if already granted)
    await _firebaseMessaging.requestPermission();

    // init further settings for notification
    initPushNotification();
  }

  // Handle received message
  Future<void> onMessageReceived(RemoteMessage? message) async {
    // if message is null, do nothing
    if (message == null) return;

    // navigate to screen when user tap notification
    // navigatorKey.currentState?.pushNamed(Routes.uikit);
  }

  // Init background setting
  Future<void> initPushNotification() async {
    // handle terminated state
    FirebaseMessaging.instance.getInitialMessage().then(onMessageReceived);

    // attach event listeners
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageReceived);
  }
}

const String firebaseMessagingScope =
    "https://www.googleapis.com/auth/firebase.messaging";
const String serviceAccountPath = "serviceAccountKey.json";

class FirebaseAccessTokenAPI {
  static String accessToken = '';

  static Future<void> claimAccessToken() async {
    final serviceAccount = await rootBundle.loadString(serviceAccountPath);
    final serviceAccountJSON = jsonDecode(serviceAccount);

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(serviceAccountJSON),
      [firebaseMessagingScope],
    );

    // Extract the access token from the credentials
    accessToken = client.credentials.accessToken.data;
    Logs.d("Firebase Access Token has been claimed");
  }
}
