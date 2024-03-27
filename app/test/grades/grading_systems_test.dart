// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

import 'grades_test_common.dart';

void main() {
  group('Grading Systems', () {
    test('A term can have a grading system.', () {
      final controller = GradesTestController();

      final term1 =
          termWith(gradingSystem: GradingSystem.oneToSixWithPlusAndMinus);
      controller.createTerm(term1);

      expect(controller.term(term1.id).gradingSystem,
          GradingSystem.oneToSixWithPlusAndMinus);
    });
    test('Basic grades test for 1+ to 6 grading system.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                // Equal to 1,75
                value: "2+",
                gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
              ),
              gradeWith(
                value: "3-",
                gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
              ),
              gradeWith(
                value: "2",
                gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .displayableGrade,
          '2,3');
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          // 2.33333...
          (1.75 + 3.25 + 2) / 3);
    });

    test('Basic grades test for 0 to 25 points grading system.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToFiveteenPoints,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 4,
                gradingSystem: GradingSystem.oneToFiveteenPoints,
              ),
              gradeWith(
                value: 8,
                gradingSystem: GradingSystem.oneToFiveteenPoints,
              ),
              gradeWith(
                value: 2,
                gradingSystem: GradingSystem.oneToFiveteenPoints,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .displayableGrade,
          '4,6');

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          // 4,6666...7
          (4 + 8 + 2) / 3);
    });
    test('The subject will use the Terms grading system by default.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            grades: [
              gradeWith(
                value: "3-", // Equal to 3.25
                gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
              ),
              // should be ignored in subject and terms calculated grade
              gradeWith(
                value: 3,
                gradingSystem: GradingSystem.oneToFiveteenPoints,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade!.asDouble, 3.25);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          3.25);
    });
    test(
        'Grades that are not in the same gradingSystem as the subject will be excluded from the calculatedGrade',
        () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToFiveteenPoints,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 4,
                gradingSystem: GradingSystem.oneToFiveteenPoints,
              ),
              gradeWith(
                value: 8,
                gradingSystem: GradingSystem.oneToFiveteenPoints,
              ),
              gradeWith(
                // TODO: I accidentally passed 2 as a number and I don't think
                // it was processed correctly. I think this should've raised an
                // error, maybe not even in the test but in the logic code.
                value: "2+",
                gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade!.asDouble, (4 + 8) / 2);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          (4 + 8) / 2);
    });

    void testThatCorrectPossibleValuesAreGivenAndInCorrectOrder(
        GradingSystem gradingSystem, Map<String, num> expected) {
      final values = GradesService().getPossibleGrades(gradingSystem);

      // Grades should be ordered from best (first) to worst (last)
      expect(values, orderedEquals(expected.keys));
    }

    void testThatGradeAsStringIsConvertedToCorrectGradeAsDoubleAndString(
        GradingSystem gradingSystem, Map<String, num> expected) {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(grades: [
          for (final entry in expected.entries)
            gradeWith(
              id: GradeId(entry.key),
              value: entry.key,
              gradingSystem: gradingSystem,
            )
        ])
      ]);
      controller.createTerm(term);

      final grades = controller.term(term.id).subjects.first.grades;

      final actual = Map.fromEntries(
        grades.map(
          (grade) => MapEntry<String, num>(
            grade.value.displayableGrade,
            grade.value.asDouble,
          ),
        ),
      );

      expect(actual, expected);
    }

    @isTestGroup
    void testGradingSystemThatUsesDiscreteValues(
        {required GradingSystem gradingSystem,
        required Map<String, num> expected}) {
      final tests = [
        (
          name:
              'returns correct possible input values sorted by best to worst grade',
          testFunc: testThatCorrectPossibleValuesAreGivenAndInCorrectOrder
        ),
        (
          name:
              'returns correct double and string grade values for grade strings',
          testFunc:
              testThatGradeAsStringIsConvertedToCorrectGradeAsDoubleAndString
        ),
      ];

      group('$gradingSystem', () {
        for (var testObj in tests) {
          test(testObj.name, () {
            testObj.testFunc(gradingSystem, expected);
          });
        }
      });
    }

    testGradingSystemThatUsesDiscreteValues(
      gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
      expected: {
        '1+': 0.75,
        '1': 1,
        '1-': 1.25,
        '2+': 1.75,
        '2': 2,
        '2-': 2.25,
        '3+': 2.75,
        '3': 3,
        '3-': 3.25,
        '4+': 3.75,
        '4': 4,
        '4-': 4.25,
        '5+': 4.75,
        '5': 5,
        '5-': 5.25,
        '6': 6,
      },
    );
    testGradingSystemThatUsesDiscreteValues(
      gradingSystem: GradingSystem.oneToFiveteenPoints,
      expected: {
        '0': 0,
        '1': 1,
        '2': 2,
        '3': 3,
        '4': 4,
        '5': 5,
        '6': 6,
        '7': 7,
        '8': 8,
        '9': 9,
        '10': 10,
        '11': 11,
        '12': 12,
        '13': 13,
        '14': 14,
        '15': 15,
      },
    );
  });
}
