// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class HomeworkAnalytics {
  final Analytics _analytics;

  HomeworkAnalytics(this._analytics);

  void logOpenHomeworkDoneByUsersList() {
    _analytics.log(HomeworkEvent('open_done_by_users_list'));
  }
}

class HomeworkEvent extends AnalyticsEvent {
  HomeworkEvent(String name) : super('homework_$name');
}