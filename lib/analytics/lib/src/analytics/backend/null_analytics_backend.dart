import '../analytics.dart';

class NullAnalyticsBackend extends AnalyticsBackend {
  @override
  void log(String name, [Map<String, dynamic> data]) {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool value) async {}

  @override
  Future<void> logSignUp({String signUpMethod}) async {}

  @override
  Future<void> setCurrentScreen({String screenName}) async {}

  @override
  Future<void> setUserProperty({String name, String value}) async {}
}

AnalyticsBackend getBackend() {
  return NullAnalyticsBackend();
}
