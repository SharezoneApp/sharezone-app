// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'internet_access_check_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'mobile_internet_access_check.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'web_internet_access_check.dart' as implementation;

Future<bool> hasInternetAccess() {
  return implementation.hasInternetAccess();
}
