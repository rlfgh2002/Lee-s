import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

///Helper class to make it easy to work SharedPreferences(or NSDefaults in iOS) using [SharedPreferences] class
///
///Use this class as database to store small and global app data
class Shared {
  static const String kIsAgreementsAccepted = 'is-agreements-accepted';
  static const String kUserId = 'firebase-user-uid';
  static const String kIsSignedIn = 'is-signed-in';
  static const String kUserName = 'user-name';
  static const String kAuthType = 'auth-method';
  static const String kUserEmail = 'user-email';
  static const String kImageUrl = 'image-url';
  static const String kLastExamId = 'last-exam-idl';

  static SharedPreferences _prefs;
  static Map<String, dynamic> _memoryPrefs = Map<String, dynamic>();

  static Future<SharedPreferences> load() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  static void setString(String key, String value) {
    _prefs.setString(key, value);
    _memoryPrefs[key] = value;
  }

  static void setInt(String key, int value) {
    _prefs.setInt(key, value);
    _memoryPrefs[key] = value;
  }

  static void setDouble(String key, double value) {
    _prefs.setDouble(key, value);
    _memoryPrefs[key] = value;
  }

  static void setBool(String key, bool value) {
    _prefs.setBool(key, value);
    _memoryPrefs[key] = value;
  }

  static String getString(String key, {String def}) {
    String val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs.getString(key);
    }
    if (val == null) {
      val = def;
    }

    return val;
  }

  static int getInt(String key, {int def}) {
    int val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs.getInt(key);
    }
    if (val == null) {
      val = def;
    }

    return val;
  }

  static double getDouble(String key, {double def}) {
    double val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs.getDouble(key);
    }
    if (val == null) {
      val = def;
    }

    return val;
  }

  static bool getBool(String key, {bool def = false}) {
    bool val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    if (val == null) {
      val = _prefs.getBool(key);
    }
    if (val == null) {
      val = def;
    }

    return val;
  }

  static bool initialized() {
    return _prefs != null;
  }

  static Future clear() async {
    await _prefs.clear();
    _prefs = null;
    _memoryPrefs = Map<String, dynamic>();
    return;
  }
}
