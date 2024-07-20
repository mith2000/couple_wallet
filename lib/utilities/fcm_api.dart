import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';

import '../app/pages/home/screens/love/messages/list_message_controller.dart';
import 'logs.dart';

const delayTimeSenderPrepare = Duration(seconds: 3);

class FirebaseMessagingAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.defaultImportance,
  );

  // Init notification
  Future<void> initNotification() async {
    // request permission (nothing happen if already granted)
    await _firebaseMessaging.requestPermission();

    // init further settings for notification
    initPushNotifications();
    initLocalNotifications();
  }

  // Handle received message
  Future<void> handleMessage(RemoteMessage? message, {bool isForeground = false}) async {
    // if message is null, do nothing
    if (message == null) return;

    // Wait for some seconds because sender side take time to prepare data
    // Can only improve if using WebSocket connection instead of HTTP
    await Future.delayed(delayTimeSenderPrepare);
    Logs.i("Handle message: ${message.notification?.body}");
    Get.put<ListMessageController>(
      ListMessageController(
        getUserFcmTokenUseCase: Get.find(),
        getPartnerFcmTokenUseCase: Get.find(),
        getChatSessionUseCase: Get.find(),
      ),
    );
    // Only foreground notification will disable show loading
    Get.find<ListMessageController>().getChatSession(isRefresh: !isForeground);
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings(localIcon);
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;
        if (payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(payload));
          handleMessage(message, isForeground: true);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    // Essential for iOS foreground notification
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // handle terminated state
    _firebaseMessaging.getInitialMessage().then(handleMessage);

    // attach event listeners when user open the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // handle background state
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // handle foreground state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            // importance: Importance.high,
            icon: localIcon,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );

      handleMessage(message, isForeground: true);
    });
  }
}

// Must be a top level function
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // do nothing
}

const localIcon = '@mipmap/ic_launcher';

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
    Logs.i("Firebase Access Token has been claimed");
  }
}
