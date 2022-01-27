// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
