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

import 'grades_test.dart';

void main() {
  group('Grading Systems', () {
    void testThatCorrectPossibleValuesAreGiven(
        GradingSystems gradingSystem, Map<String, num> expected) {
      final values = GradesService().getPossibleGrades(gradingSystem);

      // Grades should be ordered from best (first) to worst (last)
      expect(values, orderedEquals(expected.keys));
    }

    void testThatGradeAsStringIsConvertedToCorrectGradeAsDouble(
        GradingSystems gradingSystem, Map<String, num> expected) {
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
            grade.id.id,
            grade.doubleValue,
          ),
        ),
      );

      expect(expected, actual);
    }

    @isTestGroup
    void testGradingSystemThatUsesDiscreteValues(
        {required GradingSystems gradingSystem,
        required Map<String, num> expected}) {
      final tests = [
        (
          name: 'returns correct possible input values',
          testFunc: testThatCorrectPossibleValuesAreGiven
        ),
        (
          name: 'returns correct double grade values for grade strings',
          testFunc: testThatGradeAsStringIsConvertedToCorrectGradeAsDouble
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
      gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
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
      gradingSystem: GradingSystems.oneToFiveteenPoints,
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
