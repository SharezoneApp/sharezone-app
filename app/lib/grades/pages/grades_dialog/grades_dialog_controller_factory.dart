import 'package:crash_analytics/crash_analytics.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';

class GradesDialogControllerFactory {
  final CrashAnalytics crashAnalytics;
  final GradesService gradesService;
  final Stream<List<Course>> coursesStream;

  const GradesDialogControllerFactory({
    required this.crashAnalytics,
    required this.gradesService,
    required this.coursesStream,
  });

  GradesDialogController create() {
    return GradesDialogController(
      coursesStream: coursesStream,
      crashAnalytics: crashAnalytics,
      gradesService: gradesService,
    );
  }
}
