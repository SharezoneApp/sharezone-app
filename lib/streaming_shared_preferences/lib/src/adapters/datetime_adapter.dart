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
