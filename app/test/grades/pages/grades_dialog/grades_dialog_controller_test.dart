import 'package:analytics/analytics.dart';
import 'package:date/date.dart';
import 'package:clock/clock.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';

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

    GradesDialogController createController() {
      return GradesDialogController(
        gradesService: gradesService,
        coursesStream: Stream.value([]),
        crashAnalytics: crashAnalytics,
        analytics: analytics,
      );
    }

    setUp(() {
      gradesService = GradesService();
      gradesTestController = GradesTestController(gradesService: gradesService);
      crashAnalytics = MockCrashAnalytics();
      analytics = MockAnalytics();
      controller = createController();
    });

    test('setting multiple fields updates the view', () {
      gradesTestController.createTerm(
        termWith(
          id: TermId('foo'),
          name: 'Foo term',
          gradingSystem: GradingSystem.zeroToFifteenPoints,
          subjects: [
            subjectWith(
              id: SubjectId('maths'),
              name: 'Maths',
              grades: [gradeWith()],
            ),
          ],
        ),
      );

      controller = createController();

      // Test setting grade
      controller.setGrade('1');
      expect(controller.view.selectedGrade, '1');
      expect(controller.view.selectedGradeErrorText, null);

      // Test setting subject
      controller.setSubject(SubjectId('maths'));
      expect(controller.view.selectedSubject?.name, 'Maths');
      expect(controller.view.isSubjectMissing, false);

      // Test setting term
      controller.setTerm(TermId('foo'));
      expect(controller.view.selectedTerm?.name, 'Foo term');
      expect(controller.view.isTermMissing, false);

      // Test setting date
      controller.setDate(Date("2025-02-21"));
      expect(controller.view.selectedDate, Date("2025-02-21"));

      // Test setting grade type
      controller.setGradeType(GradeType.presentation);
      expect(controller.view.selectedGradingType, GradeType.presentation);
      expect(controller.view.isGradeTypeMissing, false);

      // Test setting title
      controller.setTitle('Test Title');
      expect(controller.view.title, 'Test Title');
      expect(controller.view.titleErrorText, null);

      // Test take into account flag
      controller.setIntegrateGradeIntoSubjectGrade(false);
      expect(controller.view.takeIntoAccount, false);
    });

    test('setting invalid grade shows error', () {
      controller.setGradingSystem(
        GradingSystem.zeroToFifteenPointsWithDecimals,
      );

      controller.setGrade('13,,2,3,3');
      expect(
        controller.view.selectedGradeErrorText,
        'Die Eingabe ist keine gültige Zahl.',
      );

      controller.setGrade('');
      expect(
        controller.view.selectedGradeErrorText,
        'Bitte eine Note eingeben.',
      );
    });

    test('resetting grade system clears grade value', () {
      controller = createController();

      controller.setGrade('1');
      expect(controller.view.selectedGrade, '1');

      controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);
      expect(controller.view.selectedGrade, null);
    });

    test('changing term updates grading system if no grade entered', () {
      gradesTestController.createTerm(
        termWith(
          id: TermId('term1'),
          gradingSystem: GradingSystem.zeroToFifteenPoints,
        ),
      );

      controller = createController();
      controller.setTerm(TermId('term1'));

      expect(
        controller.view.selectedGradingSystem,
        GradingSystem.zeroToFifteenPoints,
      );
    });

    test('changing term preserves grading system if grade already entered', () {
      gradesTestController.createTerms([
        termWith(
          id: TermId('term1'),
          gradingSystem: GradingSystem.zeroToFifteenPoints,
        ),
        termWith(
          id: TermId('term2'),
          gradingSystem: GradingSystem.oneToFiveWithDecimals,
        ),
      ]);
      controller = createController();

      controller.setTerm(TermId('term1'));
      controller.setGrade('8');
      controller.setTerm(TermId('term2'));

      expect(
        controller.view.selectedGradingSystem,
        GradingSystem.zeroToFifteenPoints,
      );
    });

    test('changing grade type updates title if empty', () {
      controller = createController();

      controller.setGradeType(GradeType.presentation);
      expect(
        controller.view.title,
        GradeType.presentation.predefinedType?.toUiString(),
      );
    });

    test('changing grade type preserves custom title', () {
      controller = createController();

      controller.setTitle('Custom Title');
      controller.setGradeType(GradeType.presentation);
      expect(controller.view.title, 'Custom Title');
    });

    test('the default date is the current day', () {
      withClock(Clock.fixed(DateTime(2025, 02, 21)), () {
        controller = createController();

        expect(controller.view.selectedDate, Date("2025-02-21"));
      });
    });

    test(
      'if there is an active term then it is the default value for the selected term',
      () {
        gradesTestController.createTerm(
          termWith(id: TermId('foo'), name: "Foo term"),
        );

        controller = createController();

        expect(controller.view.selectedTerm, (
          id: TermId('foo'),
          name: "Foo term",
        ));
      },
    );

    test(
      'if there is an active term then its grading system is the default value',
      () {
        gradesTestController.createTerm(
          termWith(gradingSystem: GradingSystem.zeroToFifteenPoints),
        );

        controller = createController();

        expect(
          controller.view.selectedGradingSystem,
          (GradingSystem.zeroToFifteenPoints),
        );
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

    test('$TakeIntoAccountState is enabled by default', () {
      controller = createController();
      expect(
        controller.view.takeIntoAccountState,
        TakeIntoAccountState.enabled,
      );
    });

    test(
      '$TakeIntoAccountState is ${TakeIntoAccountState.disabledWrongGradingSystem} when grade type has weight of zero',
      () {
        gradesTestController.createTerm(
          termWith(
            gradeTypeWeights: {GradeType.presentation.id: Weight.zero},
            subjects: [
              subjectWith(id: SubjectId('maths'), grades: [gradeWith()]),
            ],
          ),
        );

        controller = createController();
        controller.setSubject(SubjectId('maths'));
        controller.setGradeType(GradeType.presentation);

        expect(
          controller.view.takeIntoAccountState,
          TakeIntoAccountState.disabledGradeTypeWithNoWeight,
        );
      },
    );

    test(
      '$TakeIntoAccountState is ${TakeIntoAccountState.disabledWrongGradingSystem} when term and selected grading systems differ',
      () {
        gradesTestController.createTerm(
          termWith(gradingSystem: GradingSystem.zeroToFifteenPoints),
        );
        controller = createController();
        controller.setGradingSystem(GradingSystem.oneToSixWithPlusAndMinus);

        expect(
          controller.view.takeIntoAccountState,
          TakeIntoAccountState.disabledWrongGradingSystem,
        );
      },
    );

    test(
      '$TakeIntoAccountState remains enabled when term and selected grading systems match',
      () {
        gradesTestController.createTerm(
          termWith(gradingSystem: GradingSystem.zeroToFifteenPoints),
        );
        controller = createController();
        controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);

        expect(
          controller.view.takeIntoAccountState,
          TakeIntoAccountState.enabled,
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
