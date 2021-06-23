import 'package:bloc_base/bloc_base.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:rxdart/rxdart.dart';
import 'package:date/date.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/util/api/schoolClassGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';

class CalendricalEventsPageBloc extends BlocBase {
  final TimetableGateway timetabelGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;

  final _allUpcomingEventsSubject = BehaviorSubject<List<EventView>>();

  ValueStream<List<EventView>> get allUpcomingEvents => _allUpcomingEventsSubject;

  CalendricalEventsPageBloc(
    this.timetabelGateway,
    this.courseGateway,
    this.schoolClassGateway,
  ) {
    CombineLatestStream([
      timetabelGateway.streamEvents(Date.today()),
      courseGateway.getGroupInfoStream(schoolClassGateway)
    ], (streamValues) {
      List<CalendricalEvent> events = streamValues[0] ?? [];
      Map<String, GroupInfo> groupInfos = streamValues[1] ?? {};

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
