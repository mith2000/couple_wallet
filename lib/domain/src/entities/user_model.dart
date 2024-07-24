part of 'base_model.dart';

class UserModel extends BaseModel {
  final String uuid;

  // final String userName;
  final UserMetadataModel metadata;

  UserModel({
    required this.uuid,
    required this.metadata,
  });
}

class UserMetadataModel extends BaseModel {
  final String deviceId;
  final String fcmToken;

  UserMetadataModel({
    required this.deviceId,
    required this.fcmToken,
  });
}
