// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class FeedbackAnalytics extends BlocBase {
  final Analytics _analytics;

  FeedbackAnalytics(this._analytics);

  void logSendFeedback() {
    _analytics.log(NamedAnalyticsEvent(name: 'send_feedback'));
  }

  void logOpenRatingOfThankYouSheet() {
    _analytics
        .log(NamedAnalyticsEvent(name: 'feedback_thank_you_sheet_open_rating'));
  }

  @override
  void dispose() {}
}
