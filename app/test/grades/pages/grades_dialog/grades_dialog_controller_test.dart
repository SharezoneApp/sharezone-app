import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';

import '../../../../test_goldens/grades/pages/create_term_page/create_term_page_test.mocks.dart';
import '../../grades_test_common.dart';

class MockCrashAnalytics extends Mock implements CrashAnalytics {}

class MockAnalytics extends Mock implements Analytics {}

void main() {
  group('$GradesDialogController', () {
    late GradesTestController gradesTestController;
    late GradesService gradesService;
    late CrashAnalytics crashAnalytics;
    late Analytics analytics;
    late GradesDialogController controller;

    setUp(() {
      gradesService = GradesService();
      gradesTestController = GradesTestController(gradesService: gradesService);
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
      'if there is an active term then it is the default value for the selected term',
      () {
        gradesTestController.createTerm(
          termWith(id: TermId('foo'), name: "Foo term"),
        );

        controller = GradesDialogController(
          gradesService: gradesService,
          coursesStream: Stream.value([]),
          crashAnalytics: crashAnalytics,
          analytics: analytics,
        );

        expect(controller.view.selectedTerm, (
          id: TermId('foo'),
          name: "Foo term",
        ));
      },
    );

    test(
      'if there is no active term then the default $GradingSystem is ${GradingSystem.oneToSixWithPlusAndMinus}',
      () {
        expect(
          controller.view.selectedGradingSystem,
          GradingSystem.oneToSixWithPlusAndMinus,
        );
      },
    );

    test(
      '.save throws correct $InvalidFieldsSaveGradeException when no fields are filled out and save is pressed',
      () async {
        controller.setTitle('');

        expect(
          () async => await controller.save(),
          throwsA(
            InvalidFieldsSaveGradeException(
              ISet({
                GradingDialogFields.gradeValue,
                GradingDialogFields.subject,
                GradingDialogFields.term,
                GradingDialogFields.title,
              }),
            ),
          ),
        );
      },
    );
  });
}
