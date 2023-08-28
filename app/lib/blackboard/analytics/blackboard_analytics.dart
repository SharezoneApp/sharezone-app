// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class BlackboardAnalytics extends BlocBase {
  final Analytics _analytics;

  BlackboardAnalytics(this._analytics);

  void logOpenUserReadPage() {
    _analytics.log(BlackboardEvent('open_user_read_page'));
  }

  @override
  void dispose() {}
}

class BlackboardEvent extends AnalyticsEvent {
  BlackboardEvent(String name) : super('blackboard_$name');
}
