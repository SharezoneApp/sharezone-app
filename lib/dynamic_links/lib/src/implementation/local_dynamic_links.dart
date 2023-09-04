// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:dynamic_links/src/models/dynamic_link_data.dart';

import '../dynamic_links.dart';

class LocalDynamicLinks extends DynamicLinks {
  DynamicLinkData? getInitialDataReturn;
  DynamicLinkData? onLinkSuccessReturn;
  OnDynamicLinkErrorException? onLinkErrorReturn;

  @override
  Future<DynamicLinkData?> getInitialLink() async {
    return getInitialDataReturn;
  }

  @override
  void onLink({onSuccess, onError}) {
    if (onLinkSuccessReturn != null) {
      onSuccess!(onLinkSuccessReturn!);
    }
    if (onLinkErrorReturn != null) {
      onError!(onLinkErrorReturn!);
    }
  }

  @override
  Future<DynamicLinkData> getLinkData(String dynamicLink) {
    throw UnimplementedError();
  }
}
