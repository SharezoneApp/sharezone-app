import 'package:clock/clock.dart';
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

class PastCalendricalEventsPageControllerFactory {
  final SubscriptionService subscriptionService;
  final TimetableGateway timetableGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final Clock clock;

  const PastCalendricalEventsPageControllerFactory({
    required this.timetableGateway,
    required this.courseGateway,
    required this.schoolClassGateway,
    required this.clock,
    required this.subscriptionService,
  });

  PastCalendricalEventsPageController create() {
    return PastCalendricalEventsPageController(
      now: clock.now(),
      timetableGateway: timetableGateway,
      courseGateway: courseGateway,
      schoolClassGateway: schoolClassGateway,
      subscriptionService: subscriptionService,
    );
  }
}
