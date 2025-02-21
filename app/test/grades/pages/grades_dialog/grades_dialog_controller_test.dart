import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';

class MockCrashAnalytics extends Mock implements CrashAnalytics {}

class MockAnalytics extends Mock implements Analytics {}

void main() {
  group('GradesDialogController', () {
    late GradesService gradesService;
    late CrashAnalytics crashAnalytics;
    late Analytics analytics;
    late GradesDialogController controller;

    setUp(() {
      gradesService = GradesService();
      crashAnalytics = MockCrashAnalytics();
      analytics = MockAnalytics();
      controller = GradesDialogController(
        gradesService: gradesService,
        coursesStream: Stream.value([]),
        crashAnalytics: crashAnalytics,
        analytics: analytics,
      );
    });

    test(
      'throws correct $MultipleInvalidFieldsSaveGradeException when no fields are filled out and save is pressed',
      () {
        expect(
          () => controller.save(),
          throwsA(isA<MultipleInvalidFieldsSaveGradeException>()),
        );
      },
    );
  });
}
