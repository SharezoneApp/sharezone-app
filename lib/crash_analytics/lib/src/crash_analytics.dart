// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';

abstract class CrashAnalytics {
  bool? enableInDevMode;
  void crash();
  Future<void> recordFlutterError(FlutterErrorDetails details);
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    bool fatal = false,
  });
  void log(String msg);
  Future<void> setCustomKey(String key, dynamic value);
  Future<void> setUserIdentifier(String identifier);

  /// Enables/disables automatic data collection by Crashanalytics.
  Future<void> setCrashAnalyticsEnabled(bool enabled);
}
