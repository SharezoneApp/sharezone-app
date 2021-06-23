import 'package:flutter/foundation.dart';

import '../crash_analytics.dart';

class StubCrashAnalytics extends CrashAnalytics {
  @override
  void crash() {}

  @override
  void log(String msg) {}

  @override
  Future<void> recordError(exception, StackTrace stack) {
    return null;
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) {
    return null;
  }

  @override
  Future<void> setUserIdentifier(String identifier) {
    return null;
  }

  @override
  Future<void> setCustomKey(String key, value) async {}

  @override
  Future<void> setCrashAnalyticsEnabled(bool enabled) async {}
}

CrashAnalytics getCrashAnalytics() {
  return StubCrashAnalytics();
}
