import 'package:shared_preferences/shared_preferences.dart';

bool exitsInCacheAndIsTrueOrFalse(
    SharedPreferences pref, String key, bool value) {
  return pref.getKeys().contains(key) && pref.getBool(key) == value;
}