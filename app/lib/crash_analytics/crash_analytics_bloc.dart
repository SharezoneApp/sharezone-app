// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:crash_analytics/crash_analytics.dart';

/// Über [CrashAnalyticsBloc] kann innerhalb der UI [CrashAnalytics] aufgerufen
/// werden und ein Fehler gemeldet werden. [CrashAnalyticsBloc] kann zudem
/// gemockt werden, womit Widget-Tests geschrieben werden können (zuvor wurde in
/// der UI direkt `getCrashAnyltics()` aufgerufen, was keine Widget-Tests
/// ermöglichte).
///
/// ```dart
/// final crashAnalyticsBloc = BlocProvider.of<CrashAnalyticsBloc>(context).crashAnyltics;
/// ```
class CrashAnalyticsBloc extends BlocBase {
  final CrashAnalytics crashAnalytics;

  CrashAnalyticsBloc(this.crashAnalytics);

  @override
  void dispose() {}
}
