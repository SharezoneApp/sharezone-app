// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:sharezone/calendrical_events/models/calendrical_events_layout.dart';

class CalendricalEventsPageAnalytics {
  final Analytics analytics;

  const CalendricalEventsPageAnalytics(this.analytics);

  void logChangeLayout(CalendricalEventsPageLayout layout) {
    analytics.log(
      CalendricalEventsPageAnalyticsEvent(
        'changed_layout',
        data: {'layout': layout.name},
      ),
    );
  }

  void logPastEventsPageOpened() {
    analytics.log(
      const CalendricalEventsPageAnalyticsEvent('past_events_page_opened'),
    );
  }
}

class CalendricalEventsPageAnalyticsEvent extends AnalyticsEvent {
  const CalendricalEventsPageAnalyticsEvent(
    String name, {
    Map<String, dynamic>? data,
  }) : super('events_page_$name', data: data);
}
