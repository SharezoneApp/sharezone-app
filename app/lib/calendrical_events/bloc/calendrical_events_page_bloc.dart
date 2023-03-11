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
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class CalendricalEventsPageBloc extends BlocBase {
  final TimetableGateway timetabelGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;

  final _allUpcomingEventsSubject = BehaviorSubject<List<EventView>>();

  ValueStream<List<EventView>> get allUpcomingEvents =>
      _allUpcomingEventsSubject;

  CalendricalEventsPageBloc(
    this.timetabelGateway,
    this.courseGateway,
    this.schoolClassGateway,
  ) {
    CombineLatestStream([
      timetabelGateway.streamEvents(Date.today()),
      courseGateway.getGroupInfoStream(schoolClassGateway)
    ], (streamValues) {
      final events = streamValues[0] as List<CalendricalEvent> ?? [];
      final groupInfos = streamValues[1] as Map<String, GroupInfo> ?? {};

      final eventViews = events
          .map((event) =>
              EventView.fromEventAndGroupInfo(event, groupInfos[event.groupID]))
          .toList();

      return eventViews;
    }).listen(_allUpcomingEventsSubject.sink.add);
  }

  @override
  void dispose() {
    _allUpcomingEventsSubject.close();
  }
}
