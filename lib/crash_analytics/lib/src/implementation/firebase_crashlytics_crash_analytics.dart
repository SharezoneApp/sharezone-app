import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../crash_analytics.dart';

class FirebaseCrashlyticsCrashAnalytics extends CrashAnalytics {
  final FirebaseCrashlytics _crashlytics;

  FirebaseCrashlyticsCrashAnalytics(this._crashlytics);

  @override
  void crash() {
    _crashlytics.crash();
  }

  @override
  void log(String msg) {
    _crashlytics.log(msg);
  }

  @override
  Future<void> recordError(exception, StackTrace stack) {
    return _crashlytics.recordError(exception, stack);
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) {
    return _crashlytics.recordFlutterError(details);
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserIdentifier(String identifier) {
    return _crashlytics.setUserIdentifier(identifier);
  }

  @override
  Future<void> setCrashAnalyticsEnabled(bool enabled) {
    return _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}

CrashAnalytics getCrashAnalytics() {
  return FirebaseCrashlyticsCrashAnalytics(FirebaseCrashlytics.instance);
}
