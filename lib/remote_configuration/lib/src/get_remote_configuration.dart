// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'implementation/stub_remote_configuration.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/firebase_remote_configuration.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'implementation/firebase_web_remote_configuration.dart'
    as implementation;
import 'remote_configuration.dart';

RemoteConfiguration getRemoteConfiguration() {
  return implementation.getRemoteConfiguration();
}
