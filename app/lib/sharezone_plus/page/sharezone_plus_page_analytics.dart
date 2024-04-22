// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class SharezonePlusPageAnalytics {
  final Analytics analytics;

  const SharezonePlusPageAnalytics(this.analytics);

  void logOpenedAdvantage(String advantage) {
    analytics.log(
      NamedAnalyticsEvent(
        name: 'sz_plus_page_opened_advantage',
        data: {
          'advantage': advantage,
        },
      ),
    );
  }

  void logOpenedFaq(String question) {
    analytics.log(
      NamedAnalyticsEvent(
        name: 'sz_plus_page_opened_faq',
        data: {
          'question': question,
        },
      ),
    );
  }

  void logSubscribed(String period, String platform) {
    analytics.log(
      NamedAnalyticsEvent(
        name: 'sz_plus_subscribed',
        data: {
          'period': period,
          'platform': platform,
        },
      ),
    );
  }

  void logCancelledSubscription() {
    analytics.log(NamedAnalyticsEvent(name: 'sz_plus_cancelled'));
  }

  void logOpenGitHub() {
    analytics.log(NamedAnalyticsEvent(name: 'sz_plus_page_opened_github'));
  }
}
