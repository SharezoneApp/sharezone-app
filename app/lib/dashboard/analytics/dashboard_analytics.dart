// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class DashboardAnalytics {
  final Analytics _analytics;

  DashboardAnalytics(this._analytics);

  void logOpenFabSheet() {
    _analytics.log(const AnalyticsEvent("dashboard_fab_sheet_open"));
  }

  void logBlackboardAdd() {
    _analytics.log(const AnalyticsEvent("blackboard_add_via_overview_page"));
  }

  void logEventAdd() {
    _analytics.log(const AnalyticsEvent("event_add_via_overview_page"));
  }

  void logExamAdd() {
    _analytics.log(const AnalyticsEvent("exam_add_via_overview_page"));
  }

  void logLessonAdd() {
    _analytics.log(const AnalyticsEvent("lesson_add_via_overview_page"));
  }

  void logHomeworkAdd() {
    _analytics.log(const AnalyticsEvent("homework_add_via_overview_page"));
  }
}
