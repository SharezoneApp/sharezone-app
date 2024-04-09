// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:test_randomness/test_randomness.dart';

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
              .asDouble,
          // 2.33333...
          (1.75 + 3.25 + 2) / 3);
    });
    test('1+ to 6 grading system returns correct possible values', () {
      final service = GradesService();
      final possibleGrades =
          service.getPossibleGrades(GradingSystem.oneToSixWithPlusAndMinus);

      expect(possibleGrades, isA<ContinuousNumericalPossibleGradesResult>());
      final res = (possibleGrades as ContinuousNumericalPossibleGradesResult);
      // TODO: Maybe fix: We use 0.75 here but 0.66 on 1 to 6 with decimals.
      expect(res.min, 0.75);
      expect(res.max, 6);
      expect(res.decimalsAllowed, true);
      expect(
          res.specialGrades,
          const IMapConst({
            '1+': 0.75,
            '1-': 1.25,
            '2+': 1.75,
            '2-': 2.25,
            '3+': 2.75,
            '3-': 3.25,
            '4+': 3.75,
            '4-': 4.25,
            '5+': 4.75,
            '5-': 5.25,
          }));
    });
    test('Basic grades test for 0 to 15 points grading system.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.zeroToFivteenPoints,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 4,
                gradingSystem: GradingSystem.zeroToFivteenPoints,
              ),
              gradeWith(
                value: 8,
                gradingSystem: GradingSystem.zeroToFivteenPoints,
              ),
              gradeWith(
                value: 2,
                gradingSystem: GradingSystem.zeroToFivteenPoints,
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
              .asDouble,
          // 4,6666...7
          (4 + 8 + 2) / 3);
    });
    test('0 to 15 points returns correct possible values', () {
      final service = GradesService();
      final possibleGrades =
          service.getPossibleGrades(GradingSystem.zeroToFivteenPoints);

      expect(possibleGrades, isA<ContinuousNumericalPossibleGradesResult>());
      final res = (possibleGrades as ContinuousNumericalPossibleGradesResult);
      expect(res.min, 0);
      expect(res.max, 15);
      expect(res.decimalsAllowed, false);
      expect(res.specialGrades, isEmpty);
    });

    test('Basic test for 1-5 with decimals', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToFiveWithDecimals,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 1,
                gradingSystem: GradingSystem.oneToFiveWithDecimals,
              ),
              gradeWith(
                value: 2.75,
                gradingSystem: GradingSystem.oneToFiveWithDecimals,
              ),
              gradeWith(
                value: 5,
                gradingSystem: GradingSystem.oneToFiveWithDecimals,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      const expected = (1 + 2.75 + 5) / 3;
      expect(expected, 2.9166666666666665);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          expected);
    });
    test('1-5 with decimals returns correct possible values', () {
      final service = GradesService();
      final possibleGrades =
          service.getPossibleGrades(GradingSystem.oneToFiveWithDecimals);

      expect(possibleGrades, isA<ContinuousNumericalPossibleGradesResult>());
      final res = (possibleGrades as ContinuousNumericalPossibleGradesResult);
      expect(res.min, 0.75);
      expect(res.max, 5);
      expect(res.decimalsAllowed, true);
      expect(res.specialGrades, isEmpty);
    });
    test('Basic test for Austrian behavioural grades', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.austrianBehaviouralGrades,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 'Sehr zufriedenstellend',
                gradingSystem: GradingSystem.austrianBehaviouralGrades,
              ),
              gradeWith(
                value: 'Zufriedenstellend',
                gradingSystem: GradingSystem.austrianBehaviouralGrades,
              ),
              gradeWith(
                value: 'Wenig zufriedenstellend',
                gradingSystem: GradingSystem.austrianBehaviouralGrades,
              ),
              gradeWith(
                value: 'Nicht zufriedenstellend',
                gradingSystem: GradingSystem.austrianBehaviouralGrades,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      // Don't really think a number makes sense here
      const expected = (1 + 2 + 3 + 4) / 4;
      expect(expected, 2.5);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          expected);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .grades
              .map((e) => e.value.displayableGrade),
          [
            'Sehr zufriedenstellend',
            'Zufriedenstellend',
            'Wenig zufriedenstellend',
            'Nicht zufriedenstellend'
          ]);
    });
    test('Austrian behavioural grades returns correct possible grades', () {
      final service = GradesService();
      var possibleGrades =
          service.getPossibleGrades(GradingSystem.austrianBehaviouralGrades)
              as NonNumericalPossibleGradesResult;

      expect(possibleGrades.grades, [
        'Sehr zufriedenstellend',
        'Zufriedenstellend',
        'Wenig zufriedenstellend',
        'Nicht zufriedenstellend'
      ]);
    });
    test('Basic grades test for 6 - 1 with decimals.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.sixToOneWithDecimals,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 1,
                gradingSystem: GradingSystem.sixToOneWithDecimals,
              ),
              gradeWith(
                value: 6,
                gradingSystem: GradingSystem.sixToOneWithDecimals,
              ),
              gradeWith(
                value: 2.5,
                gradingSystem: GradingSystem.sixToOneWithDecimals,
              ),
            ],
          ),
        ],
      );

      controller.createTerm(term);

      const expected = (1 + 6 + 2.5) / 3;
      expect(expected, 3.1666666666666665);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          expected);
    });
    // TODO: We never store if min or max is the best grade. Do we need to?
    test('6 - 1 with decimals grading system returns correct possible grades',
        () {
      final service = GradesService();
      var possibleGrades =
          service.getPossibleGrades(GradingSystem.sixToOneWithDecimals);

      expect(possibleGrades, isA<ContinuousNumericalPossibleGradesResult>());
      possibleGrades =
          possibleGrades as ContinuousNumericalPossibleGradesResult;
      expect(possibleGrades.min, 1);
      expect(possibleGrades.max, 6);
      expect(possibleGrades.decimalsAllowed, true);
      expect(possibleGrades.specialGrades, isEmpty);
    });
    test('Basic grades test for 1 - 6 with decimals.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToSixWithDecimals,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 2.75,
                gradingSystem: GradingSystem.oneToSixWithDecimals,
              ),
              gradeWith(
                value: 3.25,
                gradingSystem: GradingSystem.oneToSixWithDecimals,
              ),
              gradeWith(
                value: 0.75,
                gradingSystem: GradingSystem.oneToSixWithDecimals,
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
              .asDouble,
          2.25);
    });

    test('1 - 6 with decimals grading system returns correct possible grades',
        () {
      final service = GradesService();
      var possibleGrades =
          service.getPossibleGrades(GradingSystem.oneToSixWithDecimals);

      expect(possibleGrades, isA<ContinuousNumericalPossibleGradesResult>());
      possibleGrades =
          possibleGrades as ContinuousNumericalPossibleGradesResult;
      // 1+ can in some places be 0.66, so we use that here
      expect(possibleGrades.min, 0.66);
      expect(possibleGrades.max, 6);
      expect(possibleGrades.decimalsAllowed, true);
      expect(possibleGrades.specialGrades, isEmpty);
    });

    for (var gradingSystem in GradingSystem.values.numericalAndContinuous) {
      test('$gradingSystem parses basic number input correctly.', () {
        final controller = GradesTestController();
        final service = controller.service;

        controller.createTerm(termWith(
            id: const TermId('1'),
            gradingSystem: gradingSystem,
            subjects: [
              subjectWith(id: const SubjectId('math')),
            ]));

        final pg = service.getPossibleGrades(gradingSystem);
        expect(pg, isA<ContinuousNumericalPossibleGradesResult>());
        final possibleGrades = pg as ContinuousNumericalPossibleGradesResult;

        void addGrade(Object value) {
          controller.addGrade(
            termId: const TermId('1'),
            subjectId: const SubjectId('math'),
            value: gradeWith(
              value: value,
              gradingSystem: gradingSystem,
            ),
          );
        }

        if (possibleGrades.decimalsAllowed) {
          addGrade('2.75');
          addGrade('2,75');
          addGrade(2.75);
          addGrade(3);
          addGrade(3.0);
          

          expect(
              controller
                  .term(const TermId('1'))
                  .subject(const SubjectId('math'))
                  .grades
                  .map((e) => e.value.asNum),
             [2.75, 2.75, 2.75, 3, 3]);
        } else {
          addGrade('2');
          addGrade(4);
          addGrade(4.0);

          expect(
              controller
                  .term(const TermId('1'))
                  .subject(const SubjectId('math'))
                  .grades
                  .map((e) => e.value.asNum),
              [2, 4, 4]);
        }
      });
      test(
          '$gradingSystem numbers that are too high/too low with throw an $InvalidGradeValueException when added.',
          () {
        final controller = GradesTestController();
        final service = controller.service;

        controller.createTerm(termWith(
            id: const TermId('1'),
            gradingSystem: gradingSystem,
            subjects: [
              subjectWith(id: const SubjectId('math')),
            ]));

        final pg = service.getPossibleGrades(gradingSystem);
        expect(pg, isA<ContinuousNumericalPossibleGradesResult>());
        final possibleGrades = pg as ContinuousNumericalPossibleGradesResult;

        void addGrade(String value) {
          controller.addGrade(
            termId: const TermId('1'),
            subjectId: const SubjectId('math'),
            value: gradeWith(
              value: value,
              gradingSystem: gradingSystem,
            ),
          );
        }

        final aBitTooHigh =
            possibleGrades.max + (possibleGrades.decimalsAllowed ? 0.01 : 1);
        final aBitTooLow =
            possibleGrades.min - (possibleGrades.decimalsAllowed ? 0.01 : 1);
        final wayTooHigh = possibleGrades.max +
            (possibleGrades.decimalsAllowed ? 345 : 345.2341);
        final wayTooLow = possibleGrades.min -
            (possibleGrades.decimalsAllowed ? 22 : 22.2341);
        const negativeInt = -1;
        const negativeDouble = -1.0;

        for (var number in [aBitTooLow, wayTooLow, wayTooHigh, aBitTooHigh, negativeInt, negativeDouble]) {
          expect(
              () => addGrade(number.toString()),
              throwsA(InvalidGradeValueException(
                gradeInput: '$number',
                gradingSystem: gradingSystem,
              )));
        }
      });
    }

    test('Basic test for 0-100% with decimals grading system', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 33.25,
                gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
              ),
              gradeWith(
                value: 100,
                gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
              ),
              gradeWith(
                value: 0,
                gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
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
              .asDouble,
          (33.25 + 100 + 0) / 3);
    });
    test(
        '0 - 100% with decimals grading system returns correct possible grades',
        () {
      final service = GradesService();
      var possibleGrades = service
          .getPossibleGrades(GradingSystem.zeroToHundredPercentWithDecimals);

      expect(possibleGrades, isA<ContinuousNumericalPossibleGradesResult>());
      possibleGrades =
          possibleGrades as ContinuousNumericalPossibleGradesResult;
      // 1+ is 0.75 so its not actually 1-6
      expect(possibleGrades.min, 0);
      expect(possibleGrades.max, 100);
      // TODO Two systems, with and without decimals?
      expect(possibleGrades.decimalsAllowed, true);
      expect(possibleGrades.specialGrades, isEmpty);
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
                gradingSystem: GradingSystem.zeroToFivteenPoints,
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
        gradingSystem: GradingSystem.zeroToFivteenPoints,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 4,
                gradingSystem: GradingSystem.zeroToFivteenPoints,
              ),
              gradeWith(
                value: 8,
                gradingSystem: GradingSystem.zeroToFivteenPoints,
              ),
              gradeWith(
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

    test('A suffix is only returned by percentage grade system', () {
      final controller = GradesTestController();

      controller.createTerm(termWith(id: const TermId('1'), subjects: [
        subjectWith(id: const SubjectId('math')),
      ]));

      for (final gradingSystem in GradingSystem.values) {
        final gradeId = GradeId(randomAlpha(5));
        controller.addGrade(
          termId: const TermId('1'),
          subjectId: const SubjectId('math'),
          value: gradeWith(
            id: gradeId,
            value: gradingSystem.validGradeValue,
            gradingSystem: gradingSystem,
          ),
        );

        expect(
            controller
                .term(const TermId('1'))
                .subject(const SubjectId('math'))
                .grade(gradeId)
                .value
                .suffix,
            gradingSystem == GradingSystem.zeroToHundredPercentWithDecimals
                ? '%'
                : null);
      }
    });

    void testThatGradeAsStringIsConvertedToCorrectGradeAsNum(
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

      final actual = controller
          .term(term.id)
          .subjects
          .first
          .grades
          .map((element) => MapEntry(
                // grade id is the same as the input grade value string in this test
                element.id.id,
                element.value.asNum,
              ));

      expect(Map.fromEntries(actual), expected);
    }

    void testThatGradeAsNumIsConvertedToCorrectSpecialGradeString(
        GradingSystem gradingSystem,
        Map<num, String> expectedSpecialDisplayableGrades) {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(grades: [
          for (final entry in expectedSpecialDisplayableGrades.entries)
            gradeWith(
              id: GradeId(entry.value),
              value: entry.key,
              gradingSystem: gradingSystem,
            )
        ])
      ]);
      controller.createTerm(term);

      final actual = controller.term(term.id).subjects.first.grades.map(
            (element) => MapEntry(
              element.value.asNum,
              element.value.displayableGrade,
            ),
          );

      expect(Map.fromEntries(actual), expectedSpecialDisplayableGrades);
    }

    void testThatExceptionIsThrownIfGradeWithInvalidValueIsAdded(
        GradingSystem gradingSystem, Map<String, num> expected) {
      final controller = GradesTestController();

      controller.createTerm(termWith(id: const TermId('1'), subjects: [
        subjectWith(
          id: const SubjectId('math'),
        )
      ]));

      addGrade() => controller.addGrade(
            termId: const TermId('1'),
            subjectId: const SubjectId('math'),
            value: gradeWith(
              // something invalid
              value: 'F4',
              gradingSystem: gradingSystem,
            ),
          );

      addGrade2() => controller.addGrade(
            termId: const TermId('1'),
            subjectId: const SubjectId('math'),
            value: gradeWith(
              // something invalid
              value: '99999',
              gradingSystem: gradingSystem,
            ),
          );

      expect(
          addGrade,
          throwsA(InvalidGradeValueException(
            gradeInput: 'F4',
            gradingSystem: gradingSystem,
          )));

      expect(
          addGrade2,
          throwsA(InvalidGradeValueException(
            gradeInput: '99999',
            gradingSystem: gradingSystem,
          )));
    }

    @isTestGroup
    void testGradingSystem({
      required GradingSystem gradingSystem,
      required Map<String, num> expectedNumValues,
      Map<num, String> expectedSpecialDisplayableGrades = const {},
    }) {
      group('$gradingSystem', () {
        test('returns correct num grade values for grade strings', () {
          testThatGradeAsStringIsConvertedToCorrectGradeAsNum(
              gradingSystem, expectedNumValues);
        });

        if (expectedSpecialDisplayableGrades.isNotEmpty) {
          test(
              'returns correct special string display values for grade strings',
              () {
            testThatGradeAsNumIsConvertedToCorrectSpecialGradeString(
                gradingSystem, expectedSpecialDisplayableGrades);
          });
        }

        test('throws an exception if a grade with an invalid value is added',
            () {
          testThatExceptionIsThrownIfGradeWithInvalidValueIsAdded(
              gradingSystem, expectedNumValues);
        });
      });
    }

    testGradingSystem(
      gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
      expectedNumValues: {
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
      expectedSpecialDisplayableGrades: {
        0.75: '1+',
        1.25: '1-',
        1.75: '2+',
        2.25: '2-',
        2.75: '3+',
        3.25: '3-',
        3.75: '4+',
        4.25: '4-',
        4.75: '5+',
        5.25: '5-',
      },
    );

    testGradingSystem(
      gradingSystem: GradingSystem.zeroToFivteenPoints,
      expectedNumValues: {
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
