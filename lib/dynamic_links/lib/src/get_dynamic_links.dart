import 'dynamic_links.dart';
import 'implementation/stub_dynamic_links.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/firebase_dynamic_links.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'implementation/stub_dynamic_links.dart'
    as implementation;

DynamicLinks getDynamicLinks() {
  return implementation.getDynamicLinks();
}
