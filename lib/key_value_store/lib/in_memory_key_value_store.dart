// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'package:key_value_store/key_value_store.dart';

class InMemoryKeyValueStore extends KeyValueStore {
  Map<String, dynamic> storedValues;

  InMemoryKeyValueStore([this.storedValues = const {}]);

  @override
  Future<bool> clear() async {
    storedValues.clear();
    return true;
  }

  @override
  bool getBool(String key) {
    return storedValues[key] as bool;
  }

  @override
  double getDouble(String key) {
    return storedValues[key] as double;
  }

  @override
  int getInt(String key) {
    return storedValues[key] as int;
  }

  @override
  Set<String> getKeys() {
    return storedValues.keys.toSet();
  }

  @override
  String getString(String key) {
    return storedValues[key] as String;
  }

  @override
  List<String> getStringList(String key) {
    return storedValues[key] as List<String>;
  }

  @override
  Future<bool> remove(String key) {
    return Future.value(storedValues.remove(key) != null);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    storedValues[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    storedValues[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setInt(String key, int value) {
    storedValues[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setString(String key, String value) {
    storedValues[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setStringList(String key, List<String> values) {
    storedValues[key] = values;
    return Future.value(true);
  }

  @override
  bool containsKey(String key) => storedValues.containsKey(key);
}
