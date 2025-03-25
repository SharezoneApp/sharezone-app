import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

import 'grades_test_common.dart';

void main() {
  group('$GradesService', () {
    late GradesService service;
    late GradesTestController testController;

    setUp(() {
      service = GradesService();
      testController = GradesTestController(gradesService: service);
    });

    test('$GradeRef.get does not throw if not existing', () {
      testController.createTerm(
        termWith(
          id: TermId('term1'),
          subjects: [
            subjectWith(id: SubjectId('subject1'), grades: [gradeWith()]),
          ],
        ),
      );

      expect(
        service
            .term(TermId('term1'))
            .subject(SubjectId('subject1'))
            .grade(GradeId('not-existing'))
            .get(),
        isNull,
      );
    });
  });
}
