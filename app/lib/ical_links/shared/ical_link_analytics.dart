// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:sharezone/ical_links/shared/ical_link_source.dart';

class ICalLinksAnalytics {
  final Analytics analytics;

  const ICalLinksAnalytics(this.analytics);

  void logCreate(List<ICalLinkSource> sources) {
    analytics.log(
      ICalLinksEvent(
        'create',
        data: {
          'sources': sources.map((e) => e.name).toList(),
        },
      ),
    );
  }

  void logUpdateSources(List<ICalLinkSource> sources) {
    analytics.log(
      ICalLinksEvent(
        'update_sources',
        data: {
          'sources': sources.map((e) => e.name).toList(),
        },
      ),
    );
  }

  void logUpdateName() {
    analytics.log(const ICalLinksEvent('update_name'));
  }

  void logDelete() {
    analytics.log(const ICalLinksEvent('delete'));
  }
}

class ICalLinksEvent extends AnalyticsEvent {
  const ICalLinksEvent(String name, {Map<String, dynamic>? data})
      : super('ical_links_$name', data: data);
}
