import 'package:dynamic_links/src/models/dynamic_link_data.dart';

import '../dynamic_links.dart';

class LocalDynamicLinks extends DynamicLinks {
  DynamicLinkData getInitialDataReturn;
  DynamicLinkData onLinkSuccessReturn;
  OnDynamicLinkErrorException onLinkErrorReturn;

  @override
  Future<DynamicLinkData> getInitialLink() {
    return Future.value(getInitialDataReturn);
  }

  @override
  DynamicLinkData getDynamicLinkDataFromMap(Map linkData) {
    throw UnimplementedError();
  }

  @override
  void onLink({onSuccess, onError}) {
    if (onLinkSuccessReturn != null) {
      onSuccess(onLinkSuccessReturn);
    }
    if (onLinkErrorReturn != null) {
      onError(onLinkErrorReturn);
    }
  }

  @override
  Future<DynamicLinkData> getLinkData(String dynamicLink) {
    throw UnimplementedError();
  }
}
