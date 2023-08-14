// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:dynamic_links/src/models/dynamic_link_data.dart';

import '../dynamic_links.dart';

class StubDynamicLinks extends DynamicLinks {
  @override
  Future<DynamicLinkData>? getInitialLink() {
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
