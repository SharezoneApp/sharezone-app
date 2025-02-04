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
  });
}
