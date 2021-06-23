import 'internet_access_check_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'mobile_internet_access_check.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'web_internet_access_check.dart' as implementation;

Future<bool> hasInternetAccess() {
  return implementation.hasInternetAccess();
}
