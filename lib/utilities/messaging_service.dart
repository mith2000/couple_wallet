import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app/services/app_error_handling_service.dart';
import '../firebase_options.dart';
import 'fcm_api.dart';
import 'logs.dart';

class MessagingService {
  static String get urlFcmApiV1 => 'https://fcm.googleapis.com/v1';

  static String messageSend(String projectId) => '$urlFcmApiV1/projects/$projectId/messages:send';

  static Future<void> sendNotification({
    required String targetToken,
    required String title,
    required String body,
    Function? onSuccess,
    Function? onFail,
  }) async {
    final serverKey = FirebaseAccessTokenAPI.accessToken;
    final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

    final Map<String, dynamic> notification = {
      'message': {
        'token': targetToken,
        'notification': {
          'body': body,
        },
        "android": {
          "notification": {
            "channel_id": androidHighImportanceChannelId,
            "notification_priority": "priority_high",
            "visibility": "public",
            "image":
                "https://firebasestorage.googleapis.com/v0/b/couple-wallet-15a7a.appspot.com/o/app_icon.png?alt=media&token=aa0db0ba-ced2-4d3e-94b9-ec14347cb633"
          },
          "priority": "high",
        },
        "apns": {
          "headers": {"apns-priority": "5"}
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
      Get.find<AppErrorHandlingService>().showErrorSnackBar(response.body);
    }
  }
}
