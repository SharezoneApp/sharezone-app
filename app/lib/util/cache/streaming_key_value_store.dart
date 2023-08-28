// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

abstract class StreamingKeyValueStore {
  /// Emits all the keys that currently exist - which means keys that have a
  /// non-null value.
  ///
  /// Whenever there's a value associated for a new key, emits all the existing
  /// keys along the newly added key. If a value for a specific key gets removed
  /// (or set to null), emits a set of current keys without the recently removed
  /// key.
  ///
  /// If there are no keys, emits an empty [Set].
  Stream<Set<String>> getKeys();

  /// Starts with the current bool value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Stream<bool> getBool(String key, {required bool defaultValue});

  /// Starts with the current int value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Stream<int> getInt(String key, {required int defaultValue});

  /// Starts with the current double value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Stream<double> getDouble(String key, {required double defaultValue});

  /// Starts with the current String value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Stream<String> getString(String key, {required String defaultValue});

  /// Starts with the current String list value for the given [key], then emits
  /// a new value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Stream<List<String>> getStringList(String key,
      {required List<String> defaultValue});

  /// Sets a bool value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setBool(String key, bool value);

  /// Sets a int value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setInt(String key, int value);

  /// Sets a double value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setDouble(String key, double value);

  /// Sets a String value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setString(String key, String value);

  /// Sets a String list value and notifies all active listeners that there's a
  /// new value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setStringList(String key, List<String> values);

  /// Removes the value associated with [key] and notifies all active listeners
  /// that [key] was removed. When a key is removed, the listeners associated
  /// with it will emit their `defaultValue` value.
  ///
  /// Returns true if [key] was successfully removed, otherwise returns false.
  Future<bool> remove(String key);

  /// Clears the entire key-value storage by removing all keys and values.
  ///
  /// Notifies all active listeners that their keys got removed, which in turn
  /// makes them emit their respective `defaultValue` values.
  Future<bool> clear(String key);

  Future<bool> containsKey(String key);
}

class FlutterStreamingKeyValueStore extends StreamingKeyValueStore {
  FlutterStreamingKeyValueStore(this.streamingSharedPreferences);

  @protected
  final StreamingSharedPreferences streamingSharedPreferences;

  @override
  Stream<Set<String>> getKeys() {
    return streamingSharedPreferences.getKeys();
  }

  @override
  Stream<bool> getBool(String key, {required bool defaultValue}) {
    return streamingSharedPreferences.getBool(key, defaultValue: defaultValue);
  }

  @override
  Stream<int> getInt(String key, {required int defaultValue}) {
    return streamingSharedPreferences.getInt(key, defaultValue: defaultValue);
  }

  @override
  Stream<double> getDouble(String key, {required double defaultValue}) {
    return streamingSharedPreferences.getDouble(key,
        defaultValue: defaultValue);
  }

  @override
  Stream<String> getString(String key, {required String defaultValue}) {
    return streamingSharedPreferences.getString(key,
        defaultValue: defaultValue);
  }

  @override
  Stream<List<String>> getStringList(String key,
      {required List<String> defaultValue}) {
    return streamingSharedPreferences.getStringList(key,
        defaultValue: defaultValue);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return streamingSharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return streamingSharedPreferences.setInt(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return streamingSharedPreferences.setDouble(key, value);
  }

  @override
  Future<bool> setString(String key, String value) {
    return streamingSharedPreferences.setString(key, value);
  }

  @override
  Future<bool> setStringList(String key, List<String> values) {
    return streamingSharedPreferences.setStringList(key, values);
  }

  @override
  Future<bool> clear(String key) {
    return streamingSharedPreferences.clear();
  }

  @override
  Future<bool> remove(String key) {
    return streamingSharedPreferences.remove(key);
  }

  @override
  Future<bool> containsKey(String key) async {
    final keys = await streamingSharedPreferences.getKeys().first;
    return keys.contains(key);
  }
}

class InMemoryStreamingKeyValueStore extends StreamingKeyValueStore {
  late BehaviorSubject<ModifiableMapFromIMap<String, dynamic>> storedValues;

  InMemoryStreamingKeyValueStore(
      [ModifiableMapFromIMap<String, dynamic>? storedValues]) {
    this.storedValues =
        BehaviorSubject.seeded(storedValues ?? ModifiableMapFromIMap(IMap()));
  }

  @override
  Stream<Set<String>> getKeys() {
    return storedValues.map((value) => value.keys.toSet());
  }

  @override
  Stream<bool> getBool(String key, {required bool defaultValue}) {
    return storedValues.map((value) => (value[key] as bool?) ?? defaultValue);
  }

  @override
  Stream<int> getInt(String key, {required int defaultValue}) {
    return storedValues.map((value) => (value[key] as int?) ?? defaultValue);
  }

  @override
  Stream<double> getDouble(String key, {required double defaultValue}) {
    return storedValues.map((value) => (value[key] as double?) ?? defaultValue);
  }

  @override
  Stream<String> getString(String key, {required String defaultValue}) {
    return storedValues.map((value) => (value[key] as String?) ?? defaultValue);
  }

  @override
  Stream<List<String>> getStringList(String key,
      {required List<String> defaultValue}) {
    return storedValues
        .map((value) => (value[key] as List<String>?) ?? defaultValue);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    storedValues.valueOrNull![key] = value;
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> setInt(String key, int value) {
    storedValues.valueOrNull![key] = value;
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    storedValues.valueOrNull![key] = value;
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> setString(String key, String value) {
    storedValues.valueOrNull![key] = value;
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> setStringList(String key, List<String> values) {
    storedValues.valueOrNull![key] = values;
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> clear(String key) {
    storedValues.valueOrNull!.clear();
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> remove(String key) {
    storedValues.valueOrNull!.remove(key);
    storedValues.add(storedValues.valueOrNull!);
    return Future.value(true);
  }

  @override
  Future<bool> containsKey(String key) async {
    return storedValues.valueOrNull!.containsKey(key);
  }
}
