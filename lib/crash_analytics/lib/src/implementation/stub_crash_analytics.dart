// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

import '../crash_analytics.dart';

class StubCrashAnalytics extends CrashAnalytics {
  @override
  void crash() {}

  @override
  void log(String msg) {}

  @override
  Future<void> recordError(
    exception,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    return;
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    return;
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    return;
  }

  @override
  Future<void> setCustomKey(String key, value) async {}

  @override
  Future<void> setCrashAnalyticsEnabled(bool enabled) async {}
}

CrashAnalytics getCrashAnalytics() {
  return StubCrashAnalytics();
}
