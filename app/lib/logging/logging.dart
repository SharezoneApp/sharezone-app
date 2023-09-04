// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final szLogger = Logger('Sharezone');

void startLoggingRecording(CrashAnalytics crashAnalytics) {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    crashAnalytics
        .log('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      crashAnalytics.recordError(record.error, record.stackTrace!);
    }

    debugPrint('\n${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error} ${record.stackTrace}');
    }
    debugPrint('\n');
  });
}

extension MakeLoggerChild on Logger {
  Logger makeChild(String childName) => Logger('$fullName.$childName');
}
