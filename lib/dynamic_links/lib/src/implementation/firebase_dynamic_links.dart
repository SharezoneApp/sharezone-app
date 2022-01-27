// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:dynamic_links/test.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart' as fb;
import 'package:sharezone_utils/platform.dart';
import '../dynamic_links.dart';
import '../models/dynamic_link_data.dart';

class FirebaseDynamicLinks extends DynamicLinks {
  final fb.FirebaseDynamicLinks _firebaseDynamicLinks;

  FirebaseDynamicLinks(this._firebaseDynamicLinks);

  @override
  Future<DynamicLinkData> getInitialLink() async {
    try {
      final pending = await _firebaseDynamicLinks.getInitialLink();
      return _getPendingFromFirebase(pending);
    } catch (e) {
      return null;
    }
  }

  @override
  DynamicLinkData getDynamicLinkDataFromMap(Map linkData) {
    final pending =
        _firebaseDynamicLinks.getPendingDynamicLinkDataFromMap(linkData);
    return _getPendingFromFirebase(pending);
  }

  DynamicLinkData _getPendingFromFirebase(fb.PendingDynamicLinkData pending) {
    return DynamicLinkData(
        pending?.link,
        DynamicLinkDataAndroid(
            pending?.android?.clickTimestamp, pending?.android?.minimumVersion),
        DynamicLinkDataIOS(pending?.ios?.minimumVersion));
  }

  @override
  void onLink({onSuccess, onError}) {
    _firebaseDynamicLinks.onLink(onSuccess: (pending) async {
      onSuccess(_getPendingFromFirebase(pending));
    }, onError: (error) async {
      onError(OnDynamicLinkErrorException(
          error.code, error.message, error.details));
    });
  }

  @override
  Future<DynamicLinkData> getLinkData(String dynamicLink) {
    return _firebaseDynamicLinks
        .getDynamicLink(Uri.parse(dynamicLink))
        .then((fbData) {
      return _getPendingFromFirebase(fbData);
    });
  }
}

DynamicLinks getDynamicLinks() {
  if (PlatformCheck.isMacOS) return LocalDynamicLinks();
  return FirebaseDynamicLinks(fb.FirebaseDynamicLinks.instance);
}
