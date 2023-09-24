// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/analytics/calendrical_events_page_analytics.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_cache.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_events_layout.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class CalendricalEventsPageBloc extends BlocBase {
  final TimetableGateway timetableGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final CalendricalEventsPageCache cache;
  final CalendricalEventsPageAnalytics analytics;

  static const CalendricalEventsPageLayout defaultLayout =
      CalendricalEventsPageLayout.grid;

  final _allUpcomingEventsSubject = BehaviorSubject<List<EventView>>();
  final _layoutSubject = BehaviorSubject<CalendricalEventsPageLayout>();

  Stream<CalendricalEventsPageLayout> get layout => _layoutSubject.stream;
  ValueStream<List<EventView>> get allUpcomingEvents =>
      _allUpcomingEventsSubject;

  CalendricalEventsPageBloc(
    this.timetableGateway,
    this.courseGateway,
    this.schoolClassGateway,
    this.cache,
    this.analytics,
  ) {
    _layoutSubject.add(cache.getLayout() ?? defaultLayout);

    CombineLatestStream([
      timetableGateway.streamEvents(Date.today()),
      courseGateway.getGroupInfoStream(schoolClassGateway)
    ], (streamValues) {
      final events = streamValues[0] as List<CalendricalEvent>? ?? [];
      final groupInfos = streamValues[1] as Map<String, GroupInfo>? ?? {};

      final eventViews = events
          .map((event) =>
              EventView.fromEventAndGroupInfo(event, groupInfos[event.groupID]))
          .toList();

      return eventViews;
    }).listen(_allUpcomingEventsSubject.sink.add);
  }

  void setLayout(CalendricalEventsPageLayout layout) {
    _layoutSubject.add(layout);
    analytics.logChangeLayout(layout);
    cache.setLayout(layout);
  }

  void logPastEventsPageOpened() {
    analytics.logPastEventsPageOpened();
  }

  @override
  void dispose() {
    _layoutSubject.close();
    _allUpcomingEventsSubject.close();
  }
}
