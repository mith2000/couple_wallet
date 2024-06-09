import 'package:couple_wallet/utilities/logs.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSharedPref {
  Future<void> onInit();

  Future<void> setString(String key, String value);

  Future<void> setInt(String key, int value);

  Future<void> setBool(String key, bool value);

  Future<void> setStringList(String key, List<String> value);

  Future<void> setDouble(String key, double value);

  Future<bool> removeKey(String key);

  Future<bool> containsKey(String key);

  String getString(String key, String defaultValue);

  int getInt(String key, int defaultValue);

  bool getBool(String key, bool defaultValue);

  double getDouble(String key, double defaultValue);

  List<String> getStringList(String key, List<String> defaultValue);
}

class AppSharedPrefImpl extends AppSharedPref {
  late final SharedPreferences _storage;

  @override
  Future<void> onInit() async {
    SharedPreferences.setPrefix('myapp');
    _storage = await SharedPreferences.getInstance();
  }

  @override
  Future<void> setString(String key, String value) {
    if (kDebugMode) {
      Logs.i("======= SharedPreferences saved: {$key:$value}");
    }
    return _storage.setString(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return _storage.setInt(key, value);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _storage.setBool(key, value);
  }

  @override
  Future<void> setStringList(String key, List<String> value) {
    return _storage.setStringList(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return _storage.setDouble(key, value);
  }

  @override
  Future<bool> removeKey(String key) {
    return _storage.remove(key);
  }

  @override
  Future<bool> containsKey(String key) {
    return Future.value(_storage.containsKey(key));
  }

  @override
  String getString(String key, String defaultValue) {
    String? value = _storage.getString(key);
    if (kDebugMode) {
      Logs.i("======= SharedPreferences loaded: {$key:$value}");
    }
    return value ?? defaultValue;
  }

  @override
  int getInt(String key, int defaultValue) {
    return _storage.getInt(key) ?? defaultValue;
  }

  @override
  bool getBool(String key, bool defaultValue) {
    return _storage.getBool(key) ?? defaultValue;
  }

  @override
  List<String> getStringList(String key, List<String> defaultValue) {
    return _storage.getStringList(key) ?? defaultValue;
  }

  @override
  double getDouble(String key, double defaultValue) {
    return _storage.getDouble(key) ?? defaultValue;
  }
}
