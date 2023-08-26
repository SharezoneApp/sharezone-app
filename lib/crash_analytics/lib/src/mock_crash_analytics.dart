// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'crash_analytics.dart';

class MockCrashAnalytics implements CrashAnalytics {
  bool logCalledCrash = false;
  bool logCalledLog = false;
  bool logCalledRecordError = false;
  bool logCalledRecordFlutterError = false;
  bool logCalledSetCustomKey = false;
  bool logCalledSetUserIdentifier = false;
  bool logCalledSetCrashAnalyticsEnabled = false;
  bool isCrashAnalyticsEnabled = true;

  @override
  bool? enableInDevMode;

  @override
  void crash() {
    logCalledCrash = true;
  }

  @override
  void log(String msg) {
    logCalledLog = true;
  }

  @override
  Future<void> recordError(
    exception,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    logCalledRecordError = true;
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    logCalledRecordFlutterError = true;
  }

  @override
  Future<void> setCustomKey(String key, value) async {
    logCalledSetCustomKey = true;
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    logCalledSetUserIdentifier = true;
  }

  @override
  Future<void> setCrashAnalyticsEnabled(bool enabled) async {
    isCrashAnalyticsEnabled = enabled;
    logCalledSetCrashAnalyticsEnabled = true;
  }
}
