import 'models/dynamic_link_data.dart';

typedef OnLinkSuccessCallback = Future<dynamic> Function(
    DynamicLinkData linkData);
typedef OnLinkErrorCallback = Future<dynamic> Function(
    OnDynamicLinkErrorException error);

class OnDynamicLinkErrorException implements Exception {
  final String code, message;
  final dynamic details;
  OnDynamicLinkErrorException(this.code, this.message, this.details);
}

/// Dynamic Links API.
///
/// You can get an instance by calling [DynamicLinks.instance].
abstract class DynamicLinks {
  /// Singleton of [DynamicLinks].
  static DynamicLinks instance;

  /// Attempts to retrieve the dynamic link which launched the app.
  ///
  /// This method always returns a Future. That Future completes to null if
  /// there is no pending dynamic link or any call to this method after the
  /// the first attempt.
  Future<DynamicLinkData> getInitialLink();

  DynamicLinkData getDynamicLinkDataFromMap(Map<dynamic, dynamic> linkData);

  /// Configures onLink listeners: it has two methods for success and failure.
  void onLink({
    OnLinkSuccessCallback onSuccess,
    OnLinkErrorCallback onError,
  });

  Future<DynamicLinkData> getLinkData(String dynamicLink);
}
