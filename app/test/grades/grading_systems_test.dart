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

      // expect(
      //     controller
      //         .term(term.id)
      //         .subject(const SubjectId('Mathe'))
      //         .calculatedGrade!
      //         .displayableGrade,
      //     '2,3');
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          // 2.33333...
          (1.75 + 3.25 + 2) / 3);
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

      // expect(
      //     controller
      //         .term(term.id)
      //         .subject(const SubjectId('Mathe'))
      //         .calculatedGrade!
      //         .displayableGrade,
      //     '4,6');

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          // 4,6666...7
          (4 + 8 + 2) / 3);
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
    test('Basic grades test for 1 - 6 points with decimals.', () {
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

      // expect(
      //     controller
      //         .term(term.id)
      //         .subject(const SubjectId('Mathe'))
      //         .calculatedGrade!
      //         .displayableGrade,
      //     '2,25');

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          2.25);
    });
    test(
        '1 - 6 (actual 0.75 - 6) grading system returns correct possible grades',
        () {
      final service = GradesService();
      var possibleGrades =
          service.getPossibleGrades(GradingSystem.oneToSixWithDecimals);

      expect(possibleGrades, isA<NonDiscretePossibleGradesResult>());
      possibleGrades = possibleGrades as NonDiscretePossibleGradesResult;
      // 1+ is 0.75 so its not actually 1-6
      expect(possibleGrades.min, 0.75);
      expect(possibleGrades.max, 6);
      expect(possibleGrades.decimalsAllowed, true);
      expect(possibleGrades.isDiscrete, false);
    });
    test('1 - 6 grading system parses input grades correctly.', () {
      final controller = GradesTestController();

      controller.createTerm(termWith(
          id: const TermId('1'),
          gradingSystem: GradingSystem.oneToSixWithDecimals,
          subjects: [
            subjectWith(id: const SubjectId('math')),
          ]));

      controller.addGrade(
        termId: const TermId('1'),
        subjectId: const SubjectId('math'),
        // Using "." instead of "," is allowed
        value: gradeWith(
          value: '2.75',
          gradingSystem: GradingSystem.oneToSixWithDecimals,
        ),
      );
      controller.addGrade(
        termId: const TermId('1'),
        subjectId: const SubjectId('math'),
        // Using "," instead of "." is allowed
        value: gradeWith(
          value: '2,75',
          gradingSystem: GradingSystem.oneToSixWithDecimals,
        ),
      );

      expect(
          controller
              .term(const TermId('1'))
              .subject(const SubjectId('math'))
              .grades
              .map((e) => e.value.asNum),
          [2.75, 2.75]);
    });
    test(
        '1 - 6 grading system numbers that are too high/too low with throw an $InvalidNonDiscreteGradeValueException when added.',
        () {
      final controller = GradesTestController();

      controller.createTerm(termWith(
          id: const TermId('1'),
          gradingSystem: GradingSystem.oneToSixWithDecimals,
          subjects: [
            subjectWith(id: const SubjectId('math')),
          ]));

      void addGrade(String value) {
        controller.addGrade(
          termId: const TermId('1'),
          subjectId: const SubjectId('math'),
          value: gradeWith(
            value: value,
            gradingSystem: GradingSystem.oneToSixWithDecimals,
          ),
        );
      }

      expect(
          () => addGrade('6,1'),
          throwsA(const InvalidNonDiscreteGradeValueException(
            gradeInput: '6,1',
            gradeAsNum: 6.1,
            min: 0.75,
            max: 6,
            decimalsAllowed: true,
            gradingSystem: GradingSystem.oneToSixWithDecimals,
          )));
      expect(
          () => addGrade('0,74'),
          throwsA(const InvalidNonDiscreteGradeValueException(
            gradeInput: '0,74',
            gradeAsNum: 0.74,
            min: 0.75,
            max: 6,
            decimalsAllowed: true,
            gradingSystem: GradingSystem.oneToSixWithDecimals,
          )));
      expect(() => addGrade('6'), returnsNormally);
      expect(() => addGrade('0,75'), returnsNormally);

      expect(
          controller
              .term(const TermId('1'))
              .subject(const SubjectId('math'))
              .grades
              .map((e) => e.value.asNum),
          [6, 0.75]);
    });
    test(
        '0 - 100% with decimals grading system returns correct possible grades',
        () {
      final service = GradesService();
      var possibleGrades = service
          .getPossibleGrades(GradingSystem.zeroToHundredPercentWithDecimals);

      expect(possibleGrades, isA<NonDiscretePossibleGradesResult>());
      possibleGrades = possibleGrades as NonDiscretePossibleGradesResult;
      // 1+ is 0.75 so its not actually 1-6
      expect(possibleGrades.min, 0);
      expect(possibleGrades.max, 100);
      // TODO Two systems, with and without decimals?
      expect(possibleGrades.decimalsAllowed, true);
      expect(possibleGrades.isDiscrete, false);
    });
    test('0 - 100% with decimals grading system parses input grades correctly.',
        () {
      final controller = GradesTestController();

      controller.createTerm(termWith(
          id: const TermId('1'),
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
          subjects: [
            subjectWith(id: const SubjectId('math')),
          ]));

      controller.addGrade(
        termId: const TermId('1'),
        subjectId: const SubjectId('math'),
        // Using "." instead of "," is allowed
        value: gradeWith(
          value: '98.3',
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
        ),
      );
      controller.addGrade(
        termId: const TermId('1'),
        subjectId: const SubjectId('math'),
        // Using "," instead of "." is allowed
        value: gradeWith(
          value: '15,5',
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
        ),
      );
      controller.addGrade(
        termId: const TermId('1'),
        subjectId: const SubjectId('math'),
        value: gradeWith(
          value: '3',
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
        ),
      );

      var grades = controller
          .term(const TermId('1'))
          .subject(const SubjectId('math'))
          .grades;

      expect(grades.map((element) => element.value), [
        const GradeValue(asNum: 98.3, displayableGrade: null, suffix: '%'),
        const GradeValue(asNum: 15.5, displayableGrade: null, suffix: '%'),
        const GradeValue(asNum: 3, displayableGrade: null, suffix: '%'),
      ]);
    });
    test(
        '0 - 100% with decimals grading system numbers that are too high/too low with throw an $InvalidNonDiscreteGradeValueException when added.',
        () {
      final controller = GradesTestController();

      controller.createTerm(termWith(
          id: const TermId('1'),
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
          subjects: [
            subjectWith(id: const SubjectId('math')),
          ]));

      void addGrade(String value) {
        controller.addGrade(
          termId: const TermId('1'),
          subjectId: const SubjectId('math'),
          value: gradeWith(
            value: value,
            gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
          ),
        );
      }

      expect(
          () => addGrade('100,1'),
          throwsA(const InvalidNonDiscreteGradeValueException(
              gradeInput: '100,1',
              gradeAsNum: 100.1,
              min: 0,
              max: 100,
              decimalsAllowed: true,
              gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals)));
      expect(
          () => addGrade('-2'),
          throwsA(const InvalidNonDiscreteGradeValueException(
              gradeInput: '-2',
              gradeAsNum: -2,
              min: 0,
              max: 100,
              decimalsAllowed: true,
              gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals)));
      expect(() => addGrade('0'), returnsNormally);
      expect(() => addGrade('100'), returnsNormally);

      expect(
          controller
              .term(const TermId('1'))
              .subject(const SubjectId('math'))
              .grades
              .map((e) => e.value.asNum),
          [0, 100]);
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

    void testThatCorrectPossibleValuesAreGivenAndInCorrectOrder(
        GradingSystem gradingSystem, Map<String, num> expected) {
      final res = GradesService().getPossibleGrades(gradingSystem);

      expect(res, isA<DiscretePossibleGradesResult>());
      final values = (res as DiscretePossibleGradesResult).grades;
      // Grades should be ordered from best (first) to worst (last)
      expect(values, orderedEquals(expected.keys));
    }

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
          throwsA(InvalidDiscreteGradeValueException(
            gradeInput: 'F4',
            gradingSystem: gradingSystem,
            validValues: expected.keys.toIList(),
          )));

      expect(
          addGrade2,
          throwsA(InvalidDiscreteGradeValueException(
            gradeInput: '99999',
            gradingSystem: gradingSystem,
            validValues: expected.keys.toIList(),
          )));
    }

    @isTestGroup
    void testGradingSystemThatUsesDiscreteValues({
      required GradingSystem gradingSystem,
      required Map<String, num> expectedNumValues,
      Map<num, String> expectedSpecialDisplayableGrades = const {},
    }) {
      group('$gradingSystem', () {
        test(
            'returns correct possible input values sorted by best to worst grade',
            () {
          testThatCorrectPossibleValuesAreGivenAndInCorrectOrder(
              gradingSystem, expectedNumValues);
        });

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

    testGradingSystemThatUsesDiscreteValues(
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

    /// Don't know if this is necessary, make it non-discrete?
    testGradingSystemThatUsesDiscreteValues(
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
