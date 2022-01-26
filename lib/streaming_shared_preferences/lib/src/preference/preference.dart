// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../adapters/preference_adapter.dart';

/// A [Preference] is a single value associated with a key, which is persisted
/// using [SharedPreferences].
///
/// It is also a special type of [Stream] that emits a new value whenever the
/// value associated with [key] changes. You can use a [Preference] like you would
/// use any regular [Stream].
///
/// Whenever the backing value associated with [key] transitions from non-null to
/// null, it emits [defaultValue]. The [defaultValue] is also emitted if the value
/// is null when initially listening to the stream.
class Preference<T> extends StreamView<T> {
  /// Only exposed for internal purposes. Do not call directly.
  @visibleForTesting
  Preference.$$_private(this._preferences, this._key, this.defaultValue,
      this._adapter, this._keyChanges)
      : super(
          _keyChanges.stream.transform(
            _EmitValueChanges(_key, defaultValue, _adapter, _preferences),
          ),
        );

  /// Get the latest value from the persistent storage synchronously.
  ///
  /// If the returned value doesn't exist (=is null), returns [defaultValue].
  T getValue() => _adapter.getValue(_preferences, _key) ?? defaultValue;

  /// Update the value and notify all listeners about the new value.
  ///
  /// Returns true if the [value] was successfully set, otherwise returns false.
  Future<bool> setValue(T value) async {
    if (_key == null) {
      /// This would not normally happen - it's a special case just for `getKeys()`.
      ///
      /// As `getKeys()` returns a Set<String> which represents the keys for
      /// currently stored values, its Preference will not have a key - therefore
      /// the key will be null. This is "a bug, not a feature" - setting a value
      /// for `getKeys()` would not make sense.
      throw UnsupportedError(
        'setValue() not supported for Preference with a null key.',
      );
    }

    return _updateAndNotify(_adapter.setValue(_preferences, _key, value));
  }

  /// Clear, or in other words, remove, the value. Effectively sets the [_key]
  /// to a null value. After removing a value, the [Preference] will emit [defaultValue]
  /// once.
  ///
  /// Returns true if the clear operation was successful, otherwise returns false.
  Future<bool> clear() async {
    if (_key == null) {
      throw UnsupportedError(
        'clear() not supported for Preference with a null key.',
      );
    }

    return _updateAndNotify(_preferences.remove(_key));
  }

  /// Invokes [fn] and captures the result, notifies all listeners about an
  /// update to [_key], and then returns the previously captured result.
  Future<bool> _updateAndNotify(Future<bool> fn) async {
    final isSuccessful = await fn;
    _keyChanges.add(_key);

    return isSuccessful;
  }

  /// The fallback value to emit when there's no stored value associated
  /// with the [key].
  final T defaultValue;

  // Private fields to not clutter autocompletion results for this class.
  final SharedPreferences _preferences;
  final String _key;
  final PreferenceAdapter<T> _adapter;
  final StreamController<String> _keyChanges;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preference &&
          runtimeType == other.runtimeType &&
          _key == other._key;

  @override
  int get hashCode => _key.hashCode;
}

/// A [StreamTransformer] that starts with the current persisted value and emits
/// a new one whenever the [key] has update events.
class _EmitValueChanges<T> extends StreamTransformerBase<String, T> {
  _EmitValueChanges(
    this.key,
    this.defaultValue,
    this.valueAdapter,
    this.preferences,
  );

  final String key;
  final T defaultValue;
  final PreferenceAdapter<T> valueAdapter;
  final SharedPreferences preferences;

  T _getValueFromPersistentStorage() {
    // Return the latest value from preferences,
    // If null, returns the default value.
    return valueAdapter.getValue(preferences, key) ?? defaultValue;
  }

  @override
  Stream<T> bind(Stream<String> stream) {
    return StreamTransformer<String, T>((input, cancelOnError) {
      StreamController<T> controller;
      StreamSubscription<T> subscription;

      controller = StreamController<T>(
        sync: true,
        onListen: () {
          // When the stream is listened to, start with the current persisted
          // value.
          final value = _getValueFromPersistentStorage();
          controller.add(value);

          // Cache the last value. Caching is specific for each listener, so the
          // cached value exists inside the onListen() callback for a reason.
          T lastValue = value;

          // Whenever a key has been updated, fetch the current persisted value
          // and emit it.
          subscription = input
              .transform(_EmitOnlyMatchingKeys(key))
              .map((_) => _getValueFromPersistentStorage())
              .listen(
            (value) {
              if (value != lastValue) {
                controller.add(value);
                lastValue = value;
              }
            },
            onDone: () => controller.close(),
          );
        },
        onPause: ([resumeSignal]) => subscription.pause(resumeSignal),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel(),
      );

      return controller.stream.listen(null);
    }).bind(stream);
  }
}

/// A [StreamTransformer] that filters out values that don't match the [key].
///
/// One exception is when the [key] is null - in this case, returns the source
/// stream as is. One such case would be calling the `getKeys()` method on the
/// `StreamingSharedPreferences`, as in that case there's no specific [key].
class _EmitOnlyMatchingKeys extends StreamTransformerBase<String, String> {
  _EmitOnlyMatchingKeys(this.key);
  final String key;

  @override
  Stream<String> bind(Stream<String> stream) {
    if (key != null) {
      // If key is non-null, emit only the changes that match the key.
      // Otherwise, emit all changes.
      return stream.where((changedKey) => changedKey == key);
    }

    return stream;
  }
}

// ignore_for_file: non_constant_identifier_names
