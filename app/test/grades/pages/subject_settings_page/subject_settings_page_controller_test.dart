import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_controller.dart';

import '../../grades_test_common.dart';

void main() {
  group('$SubjectSettingsPageController', () {
    const termId = TermId('my-term');
    const subjectId = SubjectId('maths');

    late GradesTestController testController;
    late TermSubjectRef subRef;

    setUp(() {
      testController = GradesTestController();
      subRef = testController.service.term(termId).subject(subjectId);
    });

    SubjectSettingsPageController createPageController() {
      return SubjectSettingsPageController(
        subRef: subRef,
        gradesService: testController.service,
      );
    }

    test(
        'regression test: https://github.com/SharezoneApp/sharezone-app/issues/1803\n'
        'Correctly adds weights / overrides weights from term', () async {
      testController.createTerm(termWith(
        id: termId,
        finalGradeType: GradeType.schoolReportGrade.id,
        gradeTypeWeights: {
          GradeType.writtenExam.id: const Weight.factor(1.5),
        },
        subjects: [
          subjectWith(
            id: subjectId,
            weightType: WeightType.inheritFromTerm,
            // Subjects need a grade to be really created/assigned to the term.
            grades: [gradeWith()],
          ),
        ],
      ));

      var pageController = createPageController();
      await pageController.setGradeWeight(
          gradeTypeId: GradeType.presentation.id,
          weight: const Weight.factor(0.5));

      // This controller needs to be recreated, otherwise the bug won't show:
      pageController = createPageController();
      // This also can't be used instead of recreating the controller to show \
      // the bug:
      // await pumpEventQueue();

      expect(pageController.view.weights.unlockView, {
        GradeType.presentation.id: const Weight.factor(0.5),
        GradeType.writtenExam.id: const Weight.factor(1.5),
      });
      expect(pageController.view.finalGradeTypeDisplayName,
          GradeType.schoolReportGrade.predefinedType!.toUiString());
    });

    test('Correctly adds weights', () async {
      testController.createTerm(termWith(
        id: termId,
        finalGradeType: GradeType.schoolReportGrade.id,
        gradeTypeWeights: {
          GradeType.writtenExam.id: const Weight.factor(1.5),
        },
        subjects: [
          subjectWith(
            id: subjectId,
            weightType: WeightType.inheritFromTerm,
            // Subjects need a grade to be really created/assigned to the term.
            grades: [gradeWith()],
          ),
        ],
      ));

      var pageController = createPageController();
      await pageController.setGradeWeight(
          gradeTypeId: GradeType.presentation.id,
          weight: const Weight.factor(0.5));

      // This works:
      expect(pageController.view.weights.unlockView, {
        GradeType.presentation.id: const Weight.factor(0.5),
        GradeType.writtenExam.id: const Weight.factor(1.5),
      });
      expect(pageController.view.finalGradeTypeDisplayName,
          GradeType.schoolReportGrade.predefinedType!.toUiString());
    });

    test(
        'returns final grade type from term if it is not overridden by subject',
        () {
      testController.createTerm(
        termWith(
          id: termId,
          finalGradeType: GradeType.presentation.id,
          subjects: [
            subjectWith(
              id: subjectId,
              finalGradeType: null,
              // Subjects need a grade to be really created/assigned to the term.
              grades: [gradeWith()],
            ),
          ],
        ),
      );

      final pageController = createPageController();

      expect(pageController.view.finalGradeTypeDisplayName,
          GradeType.presentation.predefinedType!.toUiString());
    });

    test(
        'returns final grade type from subject if it overrides terms final grade type',
        () {
      testController.createTerm(
        termWith(
          id: termId,
          finalGradeType: GradeType.presentation.id,
          subjects: [
            subjectWith(
              id: subjectId,
              finalGradeType: GradeType.writtenExam.id,
              // Subjects need a grade to be really created/assigned to the term.
              grades: [gradeWith()],
            ),
          ],
        ),
      );

      final pageController = createPageController();

      expect(pageController.view.finalGradeTypeDisplayName,
          GradeType.writtenExam.predefinedType!.toUiString());
    });

    test(
        'returns no weights if term has no default weights and subject has no weights',
        () async {
      testController
          .createTerm(termWith(id: termId, gradeTypeWeights: {}, subjects: [
        subjectWith(
          id: subjectId,
          gradeTypeWeights: {},
          // Subjects need a grade to be really created/assigned to the term.
          grades: [gradeWith()],
        ),
      ]));

      final pageController = createPageController();

      expect(pageController.view.weights, isEmpty);
    });
    test(
        'returns term weights if subjects $WeightType is ${WeightType.inheritFromTerm}',
        () async {
      testController.createTerm(
        termWith(
          id: termId,
          gradeTypeWeights: {
            GradeType.presentation.id: const Weight.factor(0.5),
            GradeType.oralParticipation.id: const Weight.percent(200),
          },
          subjects: [
            subjectWith(
              id: subjectId,
              weightType: WeightType.inheritFromTerm,
              // Should be ignored because weights are inherited from term.
              gradeTypeWeights: {
                GradeType.presentation.id: const Weight.factor(1.5),
              },
              // Ignore developer warning related to weight settings.
              ignoreWeightTypeAssertion: true,
              // Subjects need a grade to be really created/assigned to the term.
              grades: [gradeWith()],
            ),
          ],
        ),
      );

      final pageController = createPageController();

      expect(pageController.view.weights.unlockView, {
        GradeType.presentation.id: const Weight.factor(0.5),
        GradeType.oralParticipation.id: const Weight.percent(200),
      });
    });
    test(
        'returns subject weights if subjects $WeightType is ${WeightType.perGradeType}',
        () async {
      testController.createTerm(
        termWith(
          id: termId,
          gradeTypeWeights: {
            GradeType.presentation.id: const Weight.factor(0.5),
            GradeType.oralParticipation.id: const Weight.percent(200),
          },
          subjects: [
            subjectWith(
              id: subjectId,
              weightType: WeightType.perGradeType,
              // Should be ignored because weights are inherited from term.
              gradeTypeWeights: {
                GradeType.presentation.id: const Weight.factor(1.5),
              },
              // Subjects need a grade to be really created/assigned to the term.
              grades: [gradeWith()],
            ),
          ],
        ),
      );

      final pageController = createPageController();

      expect(pageController.view.weights.unlockView, {
        GradeType.presentation.id: const Weight.factor(1.5),
      });
    });
    test(
        'throws if subjects $WeightType is ${WeightType.perGrade} as we dont support it yet',
        () async {
      testController.createTerm(
        termWith(
          id: termId,
          gradeTypeWeights: {
            GradeType.presentation.id: const Weight.factor(0.5),
            GradeType.oralParticipation.id: const Weight.percent(200),
          },
          subjects: [
            subjectWith(
              id: subjectId,
              weightType: WeightType.perGrade,
              // Subjects need a grade to be really created/assigned to the term.
              grades: [
                gradeWith(
                  value: 10,
                  gradingSystem: GradingSystem.zeroToFifteenPoints,
                ),
                gradeWith(
                  value: 12,
                  gradingSystem: GradingSystem.zeroToFifteenPoints,
                  weight: const Weight.factor(1.5),
                ),
              ],
            ),
          ],
        ),
      );

      final pageController = createPageController();

      expect(pageController.state, isA<SubjectSettingsError>());
    });
  });
}
