// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

abstract class KeyValueStore {
  /// Returns all keys in the persistent storage.
  Set<String> getKeys();

  /// Reads a value from persistent storage, throwing an exception if it's not a bool.
  bool? getBool(String key);
  bool? tryGetBool(String key) => _guard(() => getBool(key));

  /// Reads a value from persistent storage, throwing an exception if it's not an int.
  int? getInt(String key);
  int? tryGetInt(String key) => _guard(() => getInt(key));

  // Reads a value from persistent storage, throwing an exception if it's not a double.
  double? getDouble(String key);
  double? tryGetDouble(String key) => _guard(() => getDouble(key));

  // Reads a value from persistent storage, throwing an exception if it's not an String.
  String? getString(String key);
  String? tryGetString(String key) => _guard(() => getString(key));

  /// Reads a set of string values from persistent storage, throwing an exception if it's not a string set.
  List<String>? getStringList(String key);
  List<String>? tryGetStringList(String key) =>
      _guard(() => getStringList(key));

  /// Saves a boolean [value] to persistent storage in the background.
  Future<bool> setBool(String key, bool value);

  /// Saves an int [value] to persistent storage in the background.
  Future<bool> setInt(String key, int value);

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  Future<bool> setDouble(String key, double value);

  /// Saves a string [value] to persistent storage in the background.
  Future<bool> setString(String key, String value);

  /// Saves a list of strings [value] to persistent storage in the background.
  Future<bool> setStringList(String key, List<String> values);

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key);

  /// If the cache contains a value with the [key], it will returns true
  bool containsKey(String key);

  /// Completes with true once the user preferences for the app has been cleared
  Future<bool> clear();
}

T? _guard<T>(T? Function() f) {
  try {
    return f();
  } catch (_) {
    return null;
  }
}
