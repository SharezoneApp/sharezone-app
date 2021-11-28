import 'package:analytics/analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';

const groupPage = "group-page";
const schoolClassPage = "school-class-page";

class CourseCreateEvent extends AnalyticsEvent {
  CourseCreateEvent({
    @required this.subject,
    @required String name,
    @required this.type,
    @required this.via,
  })  : assert(isNotEmptyOrNull(subject) && isNotEmptyOrNull(type)),
        super(name);

  final String subject, type, via;

  @override
  Map<String, dynamic> get data => {
        'subject': subject,
        'type': type,
        'via': via,
      };
}
