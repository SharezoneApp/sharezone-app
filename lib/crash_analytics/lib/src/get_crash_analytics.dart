// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'crash_analytics.dart';
import 'implementation/stub_crash_analytics.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/firebase_crashlytics_crash_analytics.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'implementation/stub_crash_analytics.dart'
    as implementation;

CrashAnalytics getCrashAnalytics() {
  return implementation.getCrashAnalytics();
}
