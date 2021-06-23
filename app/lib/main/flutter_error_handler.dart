import 'dart:async';

import 'package:flutter/widgets.dart';

void flutterErrorHandler(FlutterErrorDetails details) {
  FlutterError.dumpErrorToConsole(details);

  // Report to the application zone to report to Crashlytics.
  Zone.current.handleUncaughtError(details.exception, details.stack);
}
