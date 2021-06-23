import 'crash_analytics.dart';
import 'implementation/stub_crash_analytics.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/firebase_crashlytics_crash_analytics.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'implementation/stub_crash_analytics.dart'
    as implementation;

CrashAnalytics getCrashAnalytics() {
  return implementation.getCrashAnalytics();
}
