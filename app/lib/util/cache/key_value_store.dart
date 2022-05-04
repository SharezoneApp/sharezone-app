// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// @dart=2.14
import 'dart:async';

import 'package:key_value_store/key_value_store.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A Flutter implementation of a multiplatform key-value store.
///
/// To use, pass it [SharedPreferences] from the `shared_preferences` Flutter
/// plugin package.
///
/// For example:
///
/// ```
/// final prefs = await SharedPreferences.getInstance();
/// final kvs = FlutterKeyValueStore(prefs);
/// kvs.setString('Hello', 'World!');
/// ```
class FlutterKeyValueStore extends KeyValueStore {
  FlutterKeyValueStore(this.preferences);

  @protected
  final SharedPreferences preferences;

  @override
  Future<bool> clear() => preferences.clear();

  @override
  bool? getBool(String key) => preferences.getBool(key);

  @override
  double? getDouble(String key) => preferences.getDouble(key);

  /// Reads a value from persistent storage, throwing an exception if it's not an int.
  @override
  int? getInt(String key) => preferences.getInt(key);

  /// Returns all keys in the persistent storage.
  @override
  Set<String> getKeys() => preferences.getKeys();

  @override
  String? getString(String key) => preferences.getString(key);

  @override
  List<String>? getStringList(String key) => preferences.getStringList(key);

  @override
  Future<bool> remove(String key) => preferences.remove(key);

  @override
  Future<bool> setBool(String key, bool value) =>
      preferences.setBool(key, value);

  @override
  Future<bool> setDouble(String key, double value) =>
      preferences.setDouble(key, value);

  /// Saves an integer [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  @override
  Future<bool> setInt(String key, int value) => preferences.setInt(key, value);

  @override
  Future<bool> setString(String key, String value) =>
      preferences.setString(key, value);

  @override
  Future<bool> setStringList(String key, List<String> values) =>
      preferences.setStringList(key, values);

  @override
  bool containsKey(String key) => preferences.containsKey(key);
}
