// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller.dart';

class PastCalendricalEventsPageAnalytics {
  final Analytics analytics;

  const PastCalendricalEventsPageAnalytics(this.analytics);

  void logChangedOrder(EventsSortingOrder order) {
    analytics.log(
      PastCalendricalEventsPageAnalyticsEvent(
        'changed_order',
        data: {'order': order.name},
      ),
    );
  }
}

class PastCalendricalEventsPageAnalyticsEvent extends AnalyticsEvent {
  const PastCalendricalEventsPageAnalyticsEvent(
    String name, {
    Map<String, dynamic>? data,
  }) : super('past_events_page_$name', data: data);
}
