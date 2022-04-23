// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapters/adapters.dart';
import 'preference/preference.dart';

/// StreamingSharedPreferences is like [SharedPreferences], but reactive.
///
/// It wraps [SharedPreferences] with a Stream-based layer, allowing you to listen
/// to changes in the underlying values.
///
/// Every `preferences.get(..)` method returns a [Preference] which is a [Stream].
/// A [Preference] emits values whenever the underlying value updates. You can also
/// obtain the current value synchronously by calling `preferences.get(..).getValue()`.
///
/// To set values, every [Preference] has a convenient `setValue()` method. You
/// can also call `preferences.set(..)` like you would do with normal [SharedPreferences].
///
/// While you can connect a [Preference] to your UI with a [StreamBuilder] widget,
/// it is recommended to use a [PreferenceBuilder], as that gets rid of the initial
/// flicker and you don't need to provide `initialData` parameter for it.
class StreamingSharedPreferences {
  static Completer<StreamingSharedPreferences> _instanceCompleter;

  /// Private constructor to prevent multiple instances. Creating multiple
  /// instances of the class breaks change detection.
  StreamingSharedPreferences._(this._preferences)
      : _keyChanges = StreamController<String>.broadcast();

  final SharedPreferences _preferences;
  final StreamController<String> _keyChanges;

  /// Obtain an instance to [StreamingSharedPreferences].
  static Future<StreamingSharedPreferences> get instance async {
    if (_instanceCompleter == null) {
      _instanceCompleter = Completer();

      debugObtainSharedPreferencesInstance.then((preferences) {
        final streamingPreferences = StreamingSharedPreferences._(preferences);
        _instanceCompleter.complete(streamingPreferences);
      });
    }

    return _instanceCompleter.future;
  }

  /// Emits all the keys that currently exist - which means keys that have a
  /// non-null value.
  ///
  /// Whenever there's a value associated for a new key, emits all the existing
  /// keys along the newly added key. If a value for a specific key gets removed
  /// (or set to null), emits a set of current keys without the recently removed
  /// key.
  ///
  /// If there are no keys, emits an empty [Set].
  Preference<Set<String>> getKeys() {
    return _getValue(
      null,
      defaultValue: Set(),
      adapter: _GetKeysAdapter.instance,
    );
  }

  /// Starts with the current bool value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Preference<bool> getBool(String key, {@required bool defaultValue}) {
    return getCustomValue(
      key,
      defaultValue: defaultValue,
      adapter: BoolAdapter.instance,
    );
  }

  /// Starts with the current int value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Preference<int> getInt(String key, {@required int defaultValue}) {
    return getCustomValue(
      key,
      defaultValue: defaultValue,
      adapter: IntAdapter.instance,
    );
  }

  /// Starts with the current double value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Preference<double> getDouble(String key, {@required double defaultValue}) {
    return getCustomValue(
      key,
      defaultValue: defaultValue,
      adapter: DoubleAdapter.instance,
    );
  }

  /// Starts with the current String value for the given [key], then emits a new
  /// value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Preference<String> getString(String key, {@required String defaultValue}) {
    return getCustomValue(
      key,
      defaultValue: defaultValue,
      adapter: StringAdapter.instance,
    );
  }

  /// Starts with the current String list value for the given [key], then emits
  /// a new value every time there are changes to the value associated with [key].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Preference<List<String>> getStringList(
    String key, {
    @required List<String> defaultValue,
  }) {
    return getCustomValue(
      key,
      defaultValue: defaultValue,
      adapter: StringListAdapter.instance,
    );
  }

  /// Creates a [Preference] with a custom type. Requires an implementation of
  /// a [PreferenceAdapter].
  ///
  /// Like all other "get()" methods, starts with a current value for the given
  /// [key], then emits a new value every time there are changes to the value
  /// associated with [key].
  ///
  /// Uses an [adapter] for storing and retrieving the custom type from the
  /// persistent storage. For an example of a custom adapter, see the source code
  /// for [getString] and [StringAdapter].
  ///
  /// If the value is null, starts with the value provided in [defaultValue]. When
  /// the value transitions from non-null to null (ie. when the value is removed),
  /// emits [defaultValue].
  Preference<T> getCustomValue<T>(
    String key, {
    @required T defaultValue,
    @required PreferenceAdapter<T> adapter,
  }) {
    assert(key != null, 'Preference key must not be null.');

    return _getValue(
      key,
      defaultValue: defaultValue,
      adapter: adapter,
    );
  }

  /// Sets a bool value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setBool(String key, bool value) {
    return setCustomValue(key, value, adapter: BoolAdapter.instance);
  }

  /// Sets a int value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setInt(String key, int value) {
    return setCustomValue(key, value, adapter: IntAdapter.instance);
  }

  /// Sets a double value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setDouble(String key, double value) {
    return setCustomValue(key, value, adapter: DoubleAdapter.instance);
  }

  /// Sets a String value and notifies all active listeners that there's a new
  /// value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setString(String key, String value) {
    return setCustomValue(key, value, adapter: StringAdapter.instance);
  }

  /// Sets a String list value and notifies all active listeners that there's a
  /// new value for the [key].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setStringList(String key, List<String> values) {
    return setCustomValue(key, values, adapter: StringListAdapter.instance);
  }

  /// Sets a value of custom type [T] and notifies all active listeners that
  /// there's a new value for the [key].
  ///
  /// Requires an implementation of a [PreferenceAdapter] for the type [T]. For an
  /// example of a custom adapter, see the source code for [setString] and
  /// [StringAdapter].
  ///
  /// Returns true if a [value] was successfully set for the [key], otherwise
  /// returns false.
  Future<bool> setCustomValue<T>(
    String key,
    T value, {
    @required PreferenceAdapter<T> adapter,
  }) {
    assert(key != null, 'key must not be null.');
    assert(adapter != null, 'PreferenceAdapter must not be null.');

    return _updateAndNotify(key, adapter.setValue(_preferences, key, value));
  }

  /// Removes the value associated with [key] and notifies all active listeners
  /// that [key] was removed. When a key is removed, the listeners associated
  /// with it will emit their `defaultValue` value.
  ///
  /// Returns true if [key] was successfully removed, otherwise returns false.
  Future<bool> remove(String key) {
    return _updateAndNotify(key, _preferences.remove(key));
  }

  /// Clears the entire key-value storage by removing all keys and values.
  ///
  /// Notifies all active listeners that their keys got removed, which in turn
  /// makes them emit their respective `defaultValue` values.
  Future<bool> clear() async {
    final keys = _preferences.getKeys();
    final isSuccessful = await _preferences.clear();
    keys.forEach(_keyChanges.add);

    return isSuccessful;
  }

  /// Invokes [fn] and captures the result, notifies all listeners about an
  /// update to [key], and then returns the previously captured result.
  Future<bool> _updateAndNotify(String key, Future<bool> fn) async {
    final isSuccessful = await fn;
    _keyChanges.add(key);

    return isSuccessful;
  }

  Preference<T> _getValue<T>(
    String key, {
    @required T defaultValue,
    @required PreferenceAdapter<T> adapter,
  }) {
    assert(adapter != null, 'PreferenceAdapter must not be null.');
    assert(defaultValue != null, 'The default value must not be null.');

    // ignore: invalid_use_of_visible_for_testing_member
    return Preference.$$_private(
      _preferences,
      key,
      defaultValue,
      adapter,
      _keyChanges,
    );
  }
}

/// A special [PreferenceAdapter] for getting all currently stored keys. Does not
/// support [set] operations.
class _GetKeysAdapter extends PreferenceAdapter<Set<String>> {
  static const instance = _GetKeysAdapter._();
  const _GetKeysAdapter._();

  @override
  Set<String> getValue(preferences, _) => preferences.getKeys();

  @override
  Future<bool> setValue(_, __, ___) =>
      throw UnsupportedError('SharedPreferences.setKeys() is not supported.');
}

/// Used for obtaining an instance of [SharedPreferences] by [StreamingSharedPreferences].
///
/// Should not be used outside of tests.
@visibleForTesting
Future<SharedPreferences> debugObtainSharedPreferencesInstance =
    SharedPreferences.getInstance();

/// Resets the singleton instance of [StreamingSharedPreferences] so that it can
/// be always tested from a clean slate. Only for testing purposes.
///
/// Should not be used outside of tests.
@visibleForTesting
void debugResetStreamingSharedPreferencesInstance() {
  StreamingSharedPreferences._instanceCompleter = null;
}
