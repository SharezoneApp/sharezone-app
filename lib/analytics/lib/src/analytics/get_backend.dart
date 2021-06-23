import 'analytics.dart';

import 'backend/null_analytics_backend.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'backend/firebase_analytics_backend.dart'
    if (dart.library.js) 'backend/firebase_web_analytics_backend.dart'
    as implementation;

AnalyticsBackend getBackend() {
  return implementation.getBackend();
}
