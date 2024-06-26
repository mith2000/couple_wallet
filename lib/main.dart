import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/services/app_binding.dart';
import 'app/services/app_locale_service.dart';
import 'app/theme/app_theme.dart';
import 'data/src/services/app_shared_pref.dart';
import 'firebase_options.dart';
import 'resources/resources.dart';
import 'utilities/fcm_api.dart';

const backgroundColor = Color(0xffFCF1DE);

void main() async {
  // Initialize Flutter Native Splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  // Configuring system UI
  await configSystemUI();

  // Initialize shared preference
  final sharePref = Get.put<AppSharedPref>(AppSharedPrefImpl());
  await sharePref.onInit();

  // Initialize localization
  final appLocale = Get.put<AppLocaleService>(AppLocaleService());

  // Initialize Firebase
  await initializeFirebase();

  runApp(App(appLocale: appLocale));
}

class App extends StatelessWidget {
  const App({super.key, required this.appLocale});

  final AppLocaleService appLocale;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: appLocale.loadCurrentLocale(),
      fallbackLocale: appLocale.fallbackLocale,
      supportedLocales: R.appLocalizationDelegate.supportedLocales,
      localizationsDelegates: const [
        R.appLocalizationDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      getPages: AppPages.routes,
      initialRoute: Routes.home,
      initialBinding: AppBinding(),
      smartManagement: SmartManagement.full,
    );
  }
}

Future<void> configSystemUI() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: backgroundColor,
    systemNavigationBarColor: backgroundColor,
  ));
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await FirebaseMessagingAPI().initNotification();
  await FirebaseAccessTokenAPI.claimAccessToken();
}
