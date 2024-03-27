// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

import 'grades_test_common.dart';

void main() {
  group('grade types', () {
    test('Correct predefined grade types are existent', () {
      final controller = GradesTestController();

      final gradeTypes = controller.getPossibleGradeTypes();

      expect(gradeTypes, [
        const GradeType(
            id: GradeTypeId('school-report-grade'),
            predefinedType: PredefinedGradeTypes.schoolReportGrade),
        const GradeType(
            id: GradeTypeId('written-exam'),
            predefinedType: PredefinedGradeTypes.writtenExam),
        const GradeType(
            id: GradeTypeId('oral-participation'),
            predefinedType: PredefinedGradeTypes.oralParticipation),
        const GradeType(
            id: GradeTypeId('vocabulary-test'),
            predefinedType: PredefinedGradeTypes.vocabularyTest),
        const GradeType(
            id: GradeTypeId('presentation'),
            predefinedType: PredefinedGradeTypes.presentation),
        const GradeType(
            id: GradeTypeId('other'),
            predefinedType: PredefinedGradeTypes.other),
      ]);
    });
    test(
        'A custom grade type can be created which will be included when getting possible grade types',
        () {
      final controller = GradesTestController();

      controller.createCustomGradeType(const GradeType(id: GradeTypeId('foo')));
      controller.createCustomGradeType(const GradeType(id: GradeTypeId('bar')));
      final gradeTypes = controller.getPossibleGradeTypes();

      expect(gradeTypes, containsOnce(const GradeType(id: GradeTypeId('foo'))));
      expect(gradeTypes, containsOnce(const GradeType(id: GradeTypeId('bar'))));
    });
    test(
        'Trying to add a grade with an non-existing gradeType will cause an UnknownGradeTypeException',
        () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('foo'),
          subjects: [subjectWith(id: const SubjectId('bar'))],
        ),
      );

      addGrade() => controller.addGrade(
            termId: const TermId('test'),
            subjectId: const SubjectId('bar'),
            value: gradeWith(value: 3, type: const GradeTypeId('test')),
          );

      expect(addGrade,
          throwsA(const GradeTypeNotFoundException(GradeTypeId('test'))));
    });
    test(
        'Adding a already existing grade type will do nothing and not throw an error',
        () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('foo'),
          subjects: [subjectWith(id: const SubjectId('bar'))],
        ),
      );

      addGrades() {
        controller
          ..createCustomGradeType(const GradeType(id: GradeTypeId('custom')))
          ..createCustomGradeType(const GradeType(id: GradeTypeId('custom')))
          ..createCustomGradeType(const GradeType.oralParticipation())
          // Should check by Id, not by object
          ..createCustomGradeType(
              GradeType(id: const GradeType.oralParticipation().id));
      }

      expect(addGrades, returnsNormally);

      final gradeTypeIds =
          controller.getPossibleGradeTypes().map((gradeType) => gradeType.id);
      expect(gradeTypeIds, containsOnce(const GradeTypeId('custom')));
      expect(
          gradeTypeIds, containsOnce(const GradeType.oralParticipation().id));
    });
  });
}
