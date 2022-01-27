// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:shared_preferences/shared_preferences.dart';

/// A [PreferenceAdapter] knows how to retrieve and store a value associated
/// with a key by using [SharedPreferences].
///
/// For examples, see:
/// * [BoolAdapter], [IntAdapter], [StringAdapter] for simple preference adapters
/// * [DateTimeAdapter] and [JsonAdapter] for more involved preference adapters
abstract class PreferenceAdapter<T> {
  const PreferenceAdapter();

  /// Retrieve a value associated with the [key] by using the [preferences].
  T getValue(SharedPreferences preferences, String key);

  /// Set a [value] for the [key] by using the [preferences].
  ///
  /// Returns true if value was successfully set, otherwise false.
  Future<bool> setValue(SharedPreferences preferences, String key, T value);
}
