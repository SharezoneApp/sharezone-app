// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/widgets.dart';

void flutterErrorHandler(FlutterErrorDetails details) {
  FlutterError.dumpErrorToConsole(details);

  // Report to the application zone to report to Crashlytics.
  Zone.current.handleUncaughtError(details.exception, details.stack);
}
