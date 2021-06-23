import 'package:dynamic_links/src/models/dynamic_link_data.dart';

import '../dynamic_links.dart';

class StubDynamicLinks extends DynamicLinks {
  @override
  DynamicLinkData getDynamicLinkDataFromMap(Map<dynamic, dynamic> linkData) {
    return null;
  }

  @override
  Future<DynamicLinkData> getInitialLink() {
    return null;
  }

  @override
  void onLink({onSuccess, onError}) {}

  @override
  Future<DynamicLinkData> getLinkData(String dynamicLink) {
    throw UnimplementedError();
  }
}

DynamicLinks getDynamicLinks() {
  return StubDynamicLinks();
}
