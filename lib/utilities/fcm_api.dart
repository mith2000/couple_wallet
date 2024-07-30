import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../app/pages/home/screens/love/messages/list_message_controller.dart';
import 'fcm_token_api.dart';

const androidHighImportanceChannelId = 'high_importance_channel';
const _delayTimeSenderPrepare = Duration(seconds: 3);

class FirebaseMessagingAPI {
  FirebaseMessagingAPI._();

  /// Cached instance of [FirebaseMessagingAPI];
  static FirebaseMessagingAPI? _instance;

  /// Returns an instance.
  static FirebaseMessagingAPI get instance {
    _instance ??= FirebaseMessagingAPI._();
    return _instance!;
  }

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    androidHighImportanceChannelId,
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
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
    await Future.delayed(_delayTimeSenderPrepare);
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
    const android = AndroidInitializationSettings(localIconDir);
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

    final platform = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
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
            icon: localIconDir,
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
