import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/src/keys/app_key.dart';
import '../firebase_options.dart';
import 'fcm_api.dart';
import 'logs.dart';

class MessagingService {
  static String get urlFcmApiV1 => 'https://fcm.googleapis.com/v1';

  static String messageSend(String projectId) => '$urlFcmApiV1/projects/$projectId/messages:send';

  static String get urlFirebaseStorage =>
      'https://firebasestorage.googleapis.com/v0/b/couple-wallet-15a7a.appspot.com';

  static String get appIconStorageEndpoint => 'app_icon.png';

  static String get queryStorageAlt => 'media';

  static String get queryStorageToken => 'aa0db0ba-ced2-4d3e-94b9-ec14347cb633';

  static String get appIconFromStorage =>
      '$urlFirebaseStorage/o/$appIconStorageEndpoint?alt=$queryStorageAlt&token=$queryStorageToken';

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
            "image": appIconFromStorage
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
        AppNetworkKey.authorization: '${AppNetworkKey.bearer} $serverKey',
        AppNetworkKey.contentType: AppNetworkKey.appJsonContentType,
      },
      body: jsonEncode(notification),
    );

    if (response.statusCode == 200) {
      onSuccess?.call();
    } else {
      onFail?.call();
      Logs.e('Error sending notification: ${response.body}');
      // Get.find<AppErrorHandlingService>().showErrorSnackBar(response.body);
    }
  }
}
