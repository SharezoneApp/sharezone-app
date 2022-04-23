// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:shared_preferences/shared_preferences.dart';

import 'preference_adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a [DateTime].
///
/// Stores values as timezone independent milliseconds from the standard Unix epoch.
class DateTimeAdapter extends PreferenceAdapter<DateTime> {
  static const instance = DateTimeAdapter._();
  const DateTimeAdapter._();

  @override
  DateTime getValue(SharedPreferences preferences, String key) {
    final value = preferences.getString(key);
    if (value == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(int.parse(value), isUtc: true);
  }

  @override
  Future<bool> setValue(
      SharedPreferences preferences, String key, DateTime value) {
    return preferences.setString(
      key,
      value?.millisecondsSinceEpoch?.toString(),
    );
  }
}
