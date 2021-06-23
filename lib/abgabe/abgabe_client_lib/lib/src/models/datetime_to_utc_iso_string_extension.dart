extension DateTimeToUtcIso8601StringExtension on DateTime {
  /// Damit alle Iso-Strings auf dem Server das selbe Format haben und somit
  /// als String einfach vergleichbar sind
  String toUtcIso8601String() {
    if (!isUtc) {
      return toUtc().toIso8601String();
    }
    return toIso8601String();
  }
}
