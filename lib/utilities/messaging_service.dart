import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/src/keys/app_key.dart';
import '../firebase_options.dart';
import 'fcm_api.dart';
import 'fcm_token_api.dart';
import 'logs.dart';

const _urlFcmApiV1 = 'https://fcm.googleapis.com/v1';

const _urlFirebaseStorage =
    'https://firebasestorage.googleapis.com/v0/b/couple-wallet-15a7a.appspot.com';

const _appIconStorageEndpoint = 'app_icon.png';

const _queryStorageAlt = 'media';

const _queryStorageToken = 'aa0db0ba-ced2-4d3e-94b9-ec14347cb633';

class MessagingService {
  MessagingService._();

  static MessagingService? _instance;

  static MessagingService get instance {
    _instance ??= MessagingService._();
    return _instance!;
  }

  String _messageSend(String projectId) => '$_urlFcmApiV1/projects/$projectId/messages:send';

  String get _appIconFromStorage =>
      '$_urlFirebaseStorage/o/$_appIconStorageEndpoint?alt=$_queryStorageAlt&token=$_queryStorageToken';

  Future<void> sendNotification({
    required String targetToken,
    required String title,
    required String body,
    Function? onSuccess,
    Function? onFail,
  }) async {
    final serverKey = FirebaseAccessTokenAPI.instance.accessToken;
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
            "image": _appIconFromStorage
          },
          "priority": "high",
        },
        "apns": {
          "headers": {"apns-priority": "5"}
        },
      },
    };

    final response = await http.post(
      Uri.parse(_messageSend(projectId)),
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
