// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'analytics.dart';

import 'backend/null_analytics_backend.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'backend/firebase_analytics_backend.dart'
    if (dart.library.js) 'backend/firebase_web_analytics_backend.dart'
    as implementation;

AnalyticsBackend getBackend() {
  return implementation.getBackend();
}
