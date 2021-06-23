import 'package:flutter/foundation.dart';

abstract class CrashAnalytics {
  bool enableInDevMode;
  void crash();
  Future<void> recordFlutterError(FlutterErrorDetails details);
  Future<void> recordError(dynamic exception, StackTrace stack);
  void log(String msg);
  Future<void> setCustomKey(String key, dynamic value);
  Future<void> setUserIdentifier(String identifier);

  /// Enables/disables automatic data collection by Crashanalytics.
  Future<void> setCrashAnalyticsEnabled(bool enabled);
}
