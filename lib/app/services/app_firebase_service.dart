import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import '../../utilities/fcm_api.dart';

class AppFirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseMessagingAPI().initNotification();
    await FirebaseAccessTokenAPI.claimAccessToken();
  }
}
