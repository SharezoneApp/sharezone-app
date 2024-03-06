// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class FeedbackHistoryPageAnalytics {
  final Analytics analytics;

  const FeedbackHistoryPageAnalytics(this.analytics);

  void logOpenedPage() {
    analytics.log(NamedAnalyticsEvent(name: 'feedback_history_opened'));
  }
}
