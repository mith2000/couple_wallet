part of 'base_param.dart';

class RegisterUserParam extends BaseParam {
  final String id;
  final String deviceId;
  final String fcmToken;

  RegisterUserParam({
    required this.id,
    required this.deviceId,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return MapJson.removeJsonIfNull({
      'id': id,
      'deviceId': deviceId,
      'fcmToken': fcmToken,
    });
  }
}
