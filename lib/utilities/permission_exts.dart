import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionExt {
  static Future<bool> onRequestPermissionNotification() async {
    await Permission.notification.request();
    return (await Permission.notification.status).isGranted;
  }

  static Future<bool> onRequestPermissionMedia() async {
    bool isBelowTiramisu = false;
    if (Platform.isAndroid) {
      // Android 13 use READ_MEDIA_IMAGES and READ_MEDIA_VIDEO permission -> Permission.photos
      // Android below 13 use READ_EXTERNAL_STORAGE permission -> Permission.storage
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      isBelowTiramisu = (int.tryParse(release) ?? 0) < 13;
    }

    isBelowTiramisu
        ? await Permission.storage.request()
        : await Permission.photos.request();
    await Permission.mediaLibrary.request();
    return (isBelowTiramisu
                ? await Permission.storage.status
                : await Permission.photos.status)
            .isGranted &&
        (await Permission.mediaLibrary.status).isGranted;
  }
}
