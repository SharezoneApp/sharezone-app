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

      expect(
          gradeTypes.map((element) => (
                id: element.id,
                predefinedType: element.predefinedType,
                displayName: element.displayName
              )),
          [
            const (
              id: GradeTypeId('school-report-grade'),
              displayName: null,
              predefinedType: PredefinedGradeTypes.schoolReportGrade
            ),
            const (
              id: GradeTypeId('written-exam'),
              displayName: null,
              predefinedType: PredefinedGradeTypes.writtenExam
            ),
            const (
              id: GradeTypeId('oral-participation'),
              displayName: null,
              predefinedType: PredefinedGradeTypes.oralParticipation
            ),
            const (
              id: GradeTypeId('vocabulary-test'),
              displayName: null,
              predefinedType: PredefinedGradeTypes.vocabularyTest
            ),
            const (
              id: GradeTypeId('presentation'),
              displayName: null,
              predefinedType: PredefinedGradeTypes.presentation
            ),
            const (
              id: GradeTypeId('other'),
              displayName: null,
              predefinedType: PredefinedGradeTypes.other
            ),
          ]);
    });
    test(
        'A custom grade type can be created which will be included when getting possible grade types',
        () {
      final controller = GradesTestController();

      controller.createCustomGradeType(
          const GradeType(id: GradeTypeId('foo'), displayName: 'foo'));
      controller.createCustomGradeType(
          const GradeType(id: GradeTypeId('bar'), displayName: 'bar'));
      final gradeTypes = controller.getPossibleGradeTypes();

      expect(
          gradeTypes,
          containsOnce(
              const GradeType(id: GradeTypeId('foo'), displayName: 'foo')));
      expect(
          gradeTypes,
          containsOnce(
              const GradeType(id: GradeTypeId('bar'), displayName: 'bar')));
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
          ..createCustomGradeType(
              const GradeType(id: GradeTypeId('custom'), displayName: 'a'))
          ..createCustomGradeType(
              const GradeType(id: GradeTypeId('custom'), displayName: 'b'))
          ..createCustomGradeType(GradeType.oralParticipation)
          // Should check by Id, not by object
          ..createCustomGradeType(
              GradeType(id: GradeType.oralParticipation.id, displayName: 'f'));
      }

      expect(addGrades, returnsNormally);

      final gradeTypeIds =
          controller.getPossibleGradeTypes().map((gradeType) => gradeType.id);
      expect(gradeTypeIds, containsOnce(const GradeTypeId('custom')));
      expect(gradeTypeIds, containsOnce(GradeType.oralParticipation.id));
    });
  });
}
