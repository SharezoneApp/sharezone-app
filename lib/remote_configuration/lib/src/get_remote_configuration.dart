// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

import 'implementation/firebase_remote_configuration.dart' as implementation;
import 'implementation/stub_remote_configuration.dart' as stub;
import 'remote_configuration.dart';

RemoteConfiguration getRemoteConfiguration() {
  return implementation.getRemoteConfiguration();
}

@visibleForTesting
RemoteConfiguration getStubRemoteConfiguration() {
  return stub.getRemoteConfiguration();
}
