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
      expect(gradeTypes, GradeType.predefinedGradeTypes);

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
    test('A custom grade type has a display name', () {
      final controller = GradesTestController();

      const gradeType = GradeType(id: GradeTypeId('foo'), displayName: 'Foo');
      controller.createCustomGradeType(gradeType);

      expect(controller.getCustomGradeTypes().single.displayName, 'Foo');
    });
    test(
        'Trying to delete an unknown custom grade type throws an $GradeTypeNotFoundException',
        () {
      final controller = GradesTestController();

      expect(() => controller.deleteCustomGradeType(const GradeTypeId('foo')),
          throwsA(const GradeTypeNotFoundException(GradeTypeId('foo'))));
    });
    test(
        'A custom grade type should be deletable if it is still assigned in weight maps',
        () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('foo'),
          gradeTypeWeights: {const GradeTypeId('foo'): const Weight.factor(2)},
          subjects: [
            subjectWith(
              id: const SubjectId('bar'),
              gradeTypeWeights: {
                const GradeTypeId('foo'): const Weight.factor(2)
              },
              weightType: WeightType.perGradeType,
              grades: [
                // Added so that the subject will definitely be created
                gradeWith(
                  id: const GradeId('bar'),
                  value: 3,
                ),
              ],
            ),
          ],
        ),
      );

      controller.deleteCustomGradeType(const GradeTypeId('foo'));

      expect(
          controller
              .getCustomGradeTypes()
              .where((element) => element.id == const GradeTypeId('foo'))
              .toList(),
          isEmpty);
    });
    test(
        'If a custom grade type is deleted then it should be removed from all weight maps',
        () {
      final controller = GradesTestController();

      controller.createTerm(termWith(
        id: const TermId('foo'),
        gradeTypeWeights: {const GradeTypeId('foo'): const Weight.factor(2)},
        subjects: [
          subjectWith(
            id: const SubjectId('bar'),
            gradeTypeWeights: {
              const GradeTypeId('foo'): const Weight.factor(2)
            },
            weightType: WeightType.perGradeType,
            grades: [
              gradeWith(
                id: const GradeId('bar'),
                type: const GradeTypeId('foo'),
                value: 3,
              ),
            ],
          ),
        ],
      ));

      controller.deleteGrade(gradeId: const GradeId('bar'));
      controller.deleteCustomGradeType(const GradeTypeId('foo'));

      controller.createCustomGradeType(
          const GradeType(id: GradeTypeId('foo'), displayName: 'foo'));
      controller.addGrade(
          termId: const TermId('foo'),
          subjectId: const SubjectId('bar'),
          value: gradeWith(value: 4, type: const GradeTypeId('foo')));
      controller.addGrade(
          termId: const TermId('foo'),
          subjectId: const SubjectId('bar'),
          value: gradeWith(value: 1, type: GradeType.other.id));

      // If the grade type weights are really removed, then the calculated grade
      // should reflect that.
      // If the grade type weights would still be there, then the calculated
      // grade would be 3, since the grade type weight for 'foo' is 2.
      expect(
          controller
              .term(const TermId('foo'))
              .subject(const SubjectId('bar'))
              .calculatedGrade!
              .asNum,
          2.5);

      // Change the weight type to inherit from term so that we can check that
      // the grade type weight are removed from the term as well.
      controller.changeWeightTypeForSubject(
          termId: const TermId('foo'),
          subjectId: const SubjectId('bar'),
          weightType: WeightType.inheritFromTerm);

      expect(
          controller
              .term(const TermId('foo'))
              .subject(const SubjectId('bar'))
              .calculatedGrade!
              .asNum,
          2.5);

      expect(controller.term(const TermId('foo')).gradeTypeWeightings, isEmpty);
      expect(
          controller
              .term(const TermId('foo'))
              .subject(const SubjectId('bar'))
              .gradeTypeWeights,
          isEmpty);
    });
    test(
        'Trying to delete a predefined grade type will throw an $ArgumentError',
        () {
      final controller = GradesTestController();

      for (final gradeType in controller.getPossibleGradeTypes()) {
        if (gradeType.predefinedType != null) {
          expect(() => controller.deleteCustomGradeType(gradeType.id),
              throwsA(isA<ArgumentError>()));
        }
      }
    });
    test(
        'Trying to delete an unknown custom grade type that is still assigned as a final grade to a term throws an $GradeTypeStillAssignedException',
        () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('foo'),
          finalGradeType: const GradeTypeId('foo'),
        ),
      );

      expect(() => controller.deleteCustomGradeType(const GradeTypeId('foo')),
          throwsA(const GradeTypeStillAssignedException(GradeTypeId('foo'))));
    });
    test(
        'Trying to delete an unknown custom grade type that is still assigned to a grade throws an $GradeTypeStillAssignedException',
        () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('foo'),
          subjects: [
            subjectWith(
              grades: [
                gradeWith(
                  type: const GradeTypeId('foo'),
                  value: 3,
                )
              ],
            ),
          ],
        ),
      );

      expect(() => controller.deleteCustomGradeType(const GradeTypeId('foo')),
          throwsA(const GradeTypeStillAssignedException(GradeTypeId('foo'))));
    });
    test(
        'A custom grade type can be deleted if it is not assigned to anything (simple case)',
        () {
      final controller = GradesTestController();
      controller.createCustomGradeType(
          const GradeType(id: GradeTypeId('foo'), displayName: 'Foo'));
      controller.deleteCustomGradeType(const GradeTypeId('foo'));

      expect(controller.getCustomGradeTypes(), isEmpty);
    });
    test('A custom grade type can be deleted if it is not assigned to anything',
        () {
      final controller = GradesTestController();

      const termId = TermId('foo');
      controller.createTerm(termWith(
        id: termId,
        finalGradeType: const GradeTypeId('foo'),
        gradeTypeWeights: {const GradeTypeId('foo'): const Weight.factor(2)},
        subjects: [
          subjectWith(
            id: const SubjectId('bar'),
            finalGradeType: const GradeTypeId('foo'),
            weightType: WeightType.perGradeType,
            gradeTypeWeights: {
              const GradeTypeId('foo'): const Weight.factor(2)
            },
            grades: [
              gradeWith(
                id: const GradeId('bar'),
                type: const GradeTypeId('foo'),
                value: 3,
              ),
            ],
          ),
        ],
      ));

      controller.changeFinalGradeTypeForSubject(
        termId: const TermId('foo'),
        subjectId: const SubjectId('bar'),
        gradeType: GradeType.other.id,
      );
      controller.changeFinalGradeTypeForTerm(
        termId: termId,
        gradeTypeId: GradeType.other.id,
      );
      controller.removeWeightTypeForSubject(
        termId: termId,
        subjectId: const SubjectId('bar'),
        gradeTypeId: const GradeTypeId('foo'),
      );
      controller.removeGradeTypeWeightForTerm(
        termId: termId,
        gradeTypeId: const GradeTypeId('foo'),
      );

      controller.deleteGrade(gradeId: const GradeId('bar'));
      controller.deleteCustomGradeType(const GradeTypeId('foo'));

      expect(controller.getCustomGradeTypes(), isEmpty);
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
    test('Trying to edit a predefined grade type will throw an ArgumentError',
        () {
      final controller = GradesTestController();

      for (final gradeType in controller.getPossibleGradeTypes()) {
        expect(
            () => controller.editCustomGradeType(gradeType.id,
                displayName: 'foo'),
            throwsArgumentError);
      }
    });
    test(
        'Trying to edit an unknown custom grade type will throw an $GradeTypeNotFoundException',
        () {
      final controller = GradesTestController();

      expect(
          () => controller.editCustomGradeType(const GradeTypeId('foo'),
              displayName: 'foo'),
          throwsA(const GradeTypeNotFoundException(GradeTypeId('foo'))));
    });
    test('One can change the name of a custom grade type', () {
      final controller = GradesTestController();
      controller.createCustomGradeType(
          const GradeType(id: GradeTypeId('foo'), displayName: 'foo'));

      controller.createTerm(termWith(
        id: const TermId('foo'),
        finalGradeType: const GradeTypeId('foo'),
        subjects: [
          subjectWith(
            id: const SubjectId('bar'),
            finalGradeType: const GradeTypeId('foo'),
            grades: [
              gradeWith(
                id: const GradeId('bar'),
                type: const GradeTypeId('foo'),
                value: 3,
              ),
            ],
          ),
        ],
      ));

      controller.editCustomGradeType(const GradeTypeId('foo'),
          displayName: 'bar');

      expect(controller.getCustomGradeTypes().single.displayName, 'bar');
      expect(controller.term(const TermId('foo')).finalGradeType.displayName,
          'bar');
    });
    test(
        'Trying to edit the name of a custom grade type to an empty string throws an $ArgumentError',
        () {
      final controller = GradesTestController();
      controller.createCustomGradeType(
          const GradeType(id: GradeTypeId('foo'), displayName: 'foo'));

      expect(
          () => controller.editCustomGradeType(const GradeTypeId('foo'),
              displayName: ''),
          throwsArgumentError);
    });
  });
}
