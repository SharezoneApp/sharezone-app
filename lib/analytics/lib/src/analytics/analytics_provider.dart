// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'analytics.dart';
import 'backend/null_analytics_backend.dart';

class AnalyticsProvider extends InheritedWidget {
  const AnalyticsProvider({
    Key? key,
    required Widget child,
    required this.analytics,
  }) : super(child: child, key: key);

  final Analytics analytics;

  static Analytics ofOrNullObject(BuildContext context) {
    AnalyticsProvider? provider =
        context.findAncestorWidgetOfExactType<AnalyticsProvider>();
    if (provider == null) {
      var loggingAnalyticsBackend = NullAnalyticsBackend();
      developer.log("""
          ATTENTION: 
          AnalyticsProvider was not found in the widget tree. 
          Using Analytics with ${loggingAnalyticsBackend.runtimeType} instead.

          This means that no AnalyticsProvider was given in the widget tree.
          This should be fixed for production use of the app.
          """);
      return Analytics(loggingAnalyticsBackend);
    }
    return provider.analytics;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
