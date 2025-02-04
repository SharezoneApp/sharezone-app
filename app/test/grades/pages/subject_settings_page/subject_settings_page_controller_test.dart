import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_controller.dart';

import '../../grades_test_common.dart';

void main() {
  group('$SubjectSettingsPageController', () {
    test(
        'returns no weights if term has no default weights and subject has no weights',
        () async {
      final testController = GradesTestController();
      const termId = TermId('1');
      testController
          .createTerm(termWith(id: termId, gradeTypeWeights: {}, subjects: [
        subjectWith(
          id: const SubjectId('maths'),
          gradeTypeWeights: {},
          // Subjects need a grade to be really created/assigned to the term.
          grades: [gradeWith()],
        ),
      ]));

      final controller = SubjectSettingsPageController(
        subRef: testController.service
            .term(termId)
            .subject(const SubjectId('maths')),
        gradesService: testController.service,
      );

      expect(controller.view.weights, isEmpty);
    });
    test(
        'returns term weights if term has default weights and subject has no weights and inherits them from term',
        () async {
      final testController = GradesTestController();
      const termId = TermId('1');
      testController.createTerm(
        termWith(
          id: termId,
          gradeTypeWeights: {
            GradeType.presentation.id: const Weight.factor(0.5)
          },
          subjects: [
            subjectWith(
              id: const SubjectId('maths'),
              gradeTypeWeights: {},
              weightType: WeightType.inheritFromTerm,
              // Subjects need a grade to be really created/assigned to the term.
              grades: [gradeWith()],
            ),
          ],
        ),
      );

      final controller = SubjectSettingsPageController(
        subRef: testController.service
            .term(termId)
            .subject(const SubjectId('maths')),
        gradesService: testController.service,
      );

      expect(controller.view.weights.unlockView, {
        GradeType.presentation.id: const Weight.factor(0.5),
      });
    });
  });
}
