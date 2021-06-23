import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone/util/api/schoolClassGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone/util/api/user_api.dart';

class DashboardGateway {
  final HomeworkGateway homeworkGateway;
  final BlackboardGateway blackboardGateway;
  final TimetableGateway timetableGateway;
  final CourseGateway courseGateway;
  final SchoolClassGateway schoolClassGateway;
  final UserGateway userGateway;

  DashboardGateway(this.homeworkGateway, this.blackboardGateway,
      this.timetableGateway, this.courseGateway, this.schoolClassGateway, this.userGateway);
}
