import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/src/keys/app_key.dart';
import '../../data/src/services/app_shared_pref.dart';

const enLocale = Locale('en', 'US');
const viLocale = Locale('vi', 'VN');

class AppLocaleService {
  List<Locale> get supportedLocales {
    return const <Locale>[
      enLocale,
      viLocale,
    ];
  }

  Locale get locale {
    final String? languageCode = Get.locale?.languageCode;
    switch (languageCode) {
      case 'en':
        return enLocale;
      case 'vi':
        return viLocale;
      default:
        return viLocale;
    }
  }

  Locale get fallbackLocale => supportedLocales.first;

  String get languageCode {
    return locale.languageCode;
  }

  String get countryCode {
    return locale.countryCode ?? '';
  }

  String get localeString {
    return "${locale.languageCode}_${locale.countryCode}";
  }

  void changeLocale(Locale locale) {
    if (_isSupported(locale)) {
      Get.updateLocale(locale);
      saveLocale(locale);
    }
  }

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  final AppSharedPref _pref = Get.find();

  Locale? loadCurrentLocale() {
    final locale = Locale(
      _pref.getString(AppPrefKey.languageCode, fallbackLocale.languageCode),
      _pref.getString(AppPrefKey.countryCode, fallbackLocale.countryCode!),
    );

    for (int index = 0; index < supportedLocales.length; index++) {
      if (supportedLocales[index].languageCode == locale.languageCode) {
        return supportedLocales[index];
      }
    }
    return Get.locale;
  }

  void saveLocale(Locale locale) async {
    _pref.setString(AppPrefKey.languageCode, locale.languageCode);
    _pref.setString(AppPrefKey.countryCode, locale.countryCode!);
  }
}
