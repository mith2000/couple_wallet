part of 'base_raw.dart';

class UserRaw extends BaseRaw<UserModel> {
  final String? id;
  final String? deviceId;
  final String? fcmToken;

  UserRaw({
    this.id,
    this.deviceId,
    this.fcmToken,
  });

  factory UserRaw.fromJson(Map<String, dynamic> json) => UserRaw(
        id: json['id'] as String?,
        deviceId: json['deviceId'] as String?,
        fcmToken: json['fcmToken'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'deviceId': deviceId,
        'fcmToken': fcmToken,
      };

  @override
  UserModel raw2Model() {
    return UserModel(
      uuid: id ?? '',
      metadata: UserMetadataModel(
        deviceId: deviceId ?? '',
        fcmToken: fcmToken ?? '',
      ),
    );
  }
}
