import 'dart:convert';

import 'package:http/http.dart' as http;

import '../firebase_options.dart';
import 'fcm_api.dart';
import 'logs.dart';

class MessagingService {
  static String messageSend(String projectId) =>
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  static Future<void> sendNotification({
    required String targetToken,
    required String title,
    required String body,
    Function? onSuccess,
    Function? onFail,
  }) async {
    final accessToken = FirebaseAccessTokenAPI.accessToken;

    final serverKey = accessToken;
    final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

    final Map<String, dynamic> notification = {
      'message': {
        'token': targetToken,
        'notification': {
          'body': body,
        },
        "android": {
          "priority": "high",
        },
        "apns":{
          "headers":{
            "apns-priority":"5"
          }
        },
      },
    };

    final response = await http.post(
      Uri.parse(messageSend(projectId)),
      headers: {
        'Authorization': 'Bearer $serverKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(notification),
    );

    if (response.statusCode == 200) {
      onSuccess?.call();
    } else {
      onFail?.call();
      Logs.e('Error sending notification: ${response.body}');
    }
  }
}
