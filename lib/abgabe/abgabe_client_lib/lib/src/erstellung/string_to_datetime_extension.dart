extension StringToDateTimeExtension on String {
  /// Ruft DateTime.parse für diesen String auf.
  DateTime toDateTime() => this != null ? DateTime.parse(this) : null;
}
