import 'package:flutter/material.dart';

import 'crash_analytics.dart';

class MockCrashAnalytics implements CrashAnalytics {
  bool logCalledCrash = false;
  bool logCalledLog = false;
  bool logCalledRecordError = false;
  bool logCalledRecordFlutterError = false;
  bool logCalledSetCustomKey = false;
  bool logCalledSetUserIdentifier = false;
  bool logCalledSetCrashAnalyticsEnabled = false;
  bool isCrashAnalyticsEnabled = true;

  @override
  bool enableInDevMode;

  @override
  void crash() {
    logCalledCrash = true;
  }

  @override
  void log(String msg) {
    logCalledLog = true;
  }

  @override
  Future<void> recordError(exception, StackTrace stack) async {
    logCalledRecordError = true;
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    logCalledRecordFlutterError = true;
  }

  @override
  Future<void> setCustomKey(String key, value) async {
    logCalledSetCustomKey = true;
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    logCalledSetUserIdentifier = true;
  }

  @override
  Future<void> setCrashAnalyticsEnabled(bool enabled) async {
    isCrashAnalyticsEnabled = enabled;
    logCalledSetCrashAnalyticsEnabled = true;
  }
}
