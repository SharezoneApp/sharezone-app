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
  group('grades', () {
    test(
        'The calculated grade of a subject is the average of the grades by default',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [gradeWith(value: 4), gradeWith(value: 1.5)]),
      ]);
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          2.75);
    });
    test(
        'The calculated grade of the term is the average of subject grades by default',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: const SubjectId('Englisch'),
            name: 'Englisch',
            grades: [gradeWith(value: 2.0), gradeWith(value: 4.0)]),
      ]);
      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade!.asDouble, 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: const SubjectId('Englisch'),
            name: 'Englisch',
            weight: const Weight.factor(0.5),
            grades: [gradeWith(value: 3.0)]),
        subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            weight: const Weight.factor(1),
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: const SubjectId('Informatik'),
            name: 'Informatik',
            // weight: const Weight.factor(2),
            // is the same as:
            weight: const Weight.percent(200),
            grades: [gradeWith(value: 1.0)]),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.5 + 1 + 2;
      const expected = (3 * 0.5 + 2 * 1 + 1 * 2) / sumOfWeights;
      expect(controller.term(term.id).calculatedGrade!.asDouble, expected);
    });
    test(
        'grades that are marked as "Nicht in den Schnitt einbeziehen" should not be included in the calculation of the subject and term grade',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: const SubjectId('Sport'),
            name: 'Sport',
            weight: const Weight.factor(0.5),
            grades: [
              gradeWith(
                  id: GradeId('grade1'),
                  value: 3.0,
                  includeInGradeCalculations: false),
              gradeWith(value: 1.5),
            ]),
      ]);
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Sport'))
              .calculatedGrade!
              .asDouble,
          1.5);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Sport'))
              .grade(GradeId('grade1'))
              .isTakenIntoAccount,
          false);

      expect(controller.term(term.id).calculatedGrade!.asDouble, 1.5);
    });
    test(
        '"Nicht in den Schnitt einbeziehen" will be deactivated if the weight of the specific grade is set to non-zero',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: const SubjectId('Sport'),
            weightType: WeightType.perGrade,
            grades: [
              gradeWith(
                id: GradeId('grade1'),
                value: 3.0,
                includeInGradeCalculations: false,
              ),
            ]),
      ]);
      controller.createTerm(term);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Sport'))
              .calculatedGrade,
          null);

      controller.changeGradeWeightsForSubject(
        termId: term.id,
        subjectId: const SubjectId('Sport'),
        weights: {
          GradeId('grade1'): const Weight.percent(100),
        },
      );

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Sport'))
              .grade(GradeId('grade1'))
              .isTakenIntoAccount,
          true);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Sport'))
              .calculatedGrade!
              .asDouble,
          3.0);
    });
    test('subjects can have custom weights per grade type (e.g. presentation)',
        () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation();
      const exam = GradeType.writtenExam();
      const vocabularyTest = GradeType.vocabularyTest();

      final term = termWith(subjects: [
        subjectWith(
            id: const SubjectId('Englisch'),
            name: 'Englisch',
            weightType: WeightType.perGradeType,
            gradeTypeWeights: {
              presentation.id: const Weight.factor(0.7),
              vocabularyTest.id: const Weight.factor(1),
              exam.id: const Weight.factor(1.5),
            },
            grades: [
              gradeWith(value: 2.0, type: presentation.id),
              gradeWith(value: 1.0, type: exam.id),
              gradeWith(value: 1.0, type: vocabularyTest.id),
            ]),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.7 + 1.5 + 1;
      const expected = (2 * 0.7 + 1 * 1.5 + 1 * 1) / sumOfWeights;
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Englisch'))
              .calculatedGrade!
              .asDouble,
          expected);
      expect(controller.term(term.id).calculatedGrade!.asDouble, expected);
    });
    test(
        'subjects can have custom weights per grade type 2 (e.g. presentation)',
        () {
      // Aus Beispiel: https://www.notenapp.com/2023/08/01/notendurchschnitt-berechnen-wie-mache-ich-es-richtig/

      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
          id: const SubjectId('Mathe'),
          name: 'Mathe',
          weightType: WeightType.perGradeType,
          // TODO: GradeTypes do not exist yet, should probably be explicitly
          // created in this and other tests?
          gradeTypeWeights: {
            const GradeTypeId('Schulaufgabe'): const Weight.factor(2),
            const GradeTypeId('Abfrage'): const Weight.factor(1),
            const GradeTypeId('Mitarbeitsnote'): const Weight.factor(1),
            const GradeTypeId('Referat'): const Weight.factor(1),
          },
          grades: [
            gradeWith(value: 2.0, type: const GradeTypeId('Schulaufgabe')),
            gradeWith(value: 3.0, type: const GradeTypeId('Schulaufgabe')),
            gradeWith(value: 1.0, type: const GradeTypeId('Abfrage')),
            gradeWith(value: 3.0, type: const GradeTypeId('Abfrage')),
            gradeWith(value: 2.0, type: const GradeTypeId('Mitarbeitsnote')),
            gradeWith(value: 1.0, type: const GradeTypeId('Referat')),
          ],
        ),
      ]);
      controller.createTerm(term, createMissingGradeTypes: true);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          2.125);
    });
    test('subjects can have custom weights per grade', () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
          id: const SubjectId('Mathe'),
          name: 'Mathe',
          weightType: WeightType.perGrade,
          grades: [
            gradeWith(value: 1.0, weight: const Weight.factor(0.2)),
            gradeWith(value: 4.0, weight: const Weight.factor(2)),
            gradeWith(value: 3.0),
          ],
        ),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.2 + 2 + 1;
      const expected = (1 * 0.2 + 4 * 2 + 3 * 1) / sumOfWeights;
      expect(expected, closeTo(3.5, 0.01));
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Mathe'))
              .calculatedGrade!
              .asDouble,
          expected);
    });
    test(
        'grades for a subject will be weighted by the settings in term by default',
        () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation();
      const exam = GradeType.writtenExam();

      final term = termWith(
        gradeTypeWeights: {
          presentation.id: const Weight.factor(1),
          exam.id: const Weight.factor(3),
        },
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            // This should be the default:
            // weightType: WeightType.inheritFromTerm,
            grades: [
              gradeWith(value: 3.0, type: presentation.id),
              gradeWith(value: 1.0, type: exam.id),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade!.asDouble, 1.5);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .calculatedGrade!
              .asDouble,
          1.5);
    });
    test('term weights can be overridden by a subject', () {
      final controller = GradesTestController();

      const subjectId = SubjectId('Deutsch');
      final grade1Id = GradeId('grade1');
      final grade2Id = GradeId('grade2');

      const presentation = GradeType.presentation();
      const exam = GradeType.writtenExam();

      final term = termWith(
        gradeTypeWeights: {
          presentation.id: const Weight.factor(1),
          exam.id: const Weight.factor(3),
        },
        subjects: [
          subjectWith(
            id: subjectId,
            name: 'Deutsch',
            weightType: WeightType.inheritFromTerm,
            grades: [
              gradeWith(
                id: grade1Id,
                value: 3.0,
                type: presentation.id,
              ),
              gradeWith(
                id: grade2Id,
                value: 1.0,
                type: exam.id,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);
      final subjectGradeWithInheritedWeights =
          controller.term(term.id).subject(subjectId).calculatedGrade!.asDouble;
      expect(subjectGradeWithInheritedWeights, 1.5);

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: subjectId,
        weightType: WeightType.perGradeType,
      );
      controller.changeTermWeightsForSubject(
        termId: term.id,
        subjectId: subjectId,
        gradeTypeWeights: {
          presentation.id: const Weight.factor(1),
          exam.id: const Weight.factor(1),
        },
      );

      final subjectWithOverriddenGradeTypeWeights =
          controller.term(term.id).subject(subjectId).calculatedGrade!.asDouble;
      expect(subjectWithOverriddenGradeTypeWeights, 2.0);
      expect(subjectWithOverriddenGradeTypeWeights,
          isNot(subjectGradeWithInheritedWeights));

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: subjectId,
        weightType: WeightType.perGrade,
      );
      controller.changeGradeWeightsForSubject(
        termId: term.id,
        subjectId: subjectId,
        weights: {
          grade1Id: const Weight.percent(85),
          grade2Id: const Weight.percent(15),
        },
      );

      final subjectWithOverriddenGradeWeights =
          controller.term(term.id).subject(subjectId).calculatedGrade!.asDouble;

      expect(subjectWithOverriddenGradeWeights,
          isNot(subjectWithOverriddenGradeTypeWeights));
      expect(subjectWithOverriddenGradeWeights,
          isNot(subjectGradeWithInheritedWeights));

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: subjectId,
        weightType: WeightType.inheritFromTerm,
      );

      expect(
          controller.term(term.id).subject(subjectId).calculatedGrade!.asDouble,
          subjectGradeWithInheritedWeights);
    });
    test(
        'a subjects gradeType weights are saved even when they are deactivated',
        () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation();
      const exam = GradeType.writtenExam();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            weightType: WeightType.perGradeType,
            gradeTypeWeights: {
              presentation.id: const Weight.factor(1),
              exam.id: const Weight.factor(3),
            },
            grades: [
              gradeWith(
                value: 3.0,
                type: presentation.id,
              ),
              gradeWith(
                value: 1.0,
                type: exam.id,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .calculatedGrade!
              .asDouble,
          1.5);

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: const SubjectId('Deutsch'),
        weightType: WeightType.inheritFromTerm,
      );
      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: const SubjectId('Deutsch'),
        weightType: WeightType.perGradeType,
      );

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .calculatedGrade!
              .asDouble,
          1.5);
    });
    test('a subjects grade weights are saved even when they are deactivated',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            weightType: WeightType.perGrade,
            grades: [
              gradeWith(
                value: 3.0,
                type: const GradeType.presentation().id,
                weight: const Weight.factor(1),
              ),
              gradeWith(
                value: 1.0,
                type: const GradeType.writtenExam().id,
                weight: const Weight.factor(3),
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .calculatedGrade!
              .asDouble,
          1.5);

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: const SubjectId('Deutsch'),
        weightType: WeightType.inheritFromTerm,
      );
      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: const SubjectId('Deutsch'),
        weightType: WeightType.perGrade,
      );

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .calculatedGrade!
              .asDouble,
          1.5);
    });
    test('The "Endnote" grade type overrides the subject grade', () {
      final controller = GradesTestController();

      final term = termWith(
        finalGradeType: const GradeType.other().id,
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [
              gradeWith(
                value: 3.0,
                type: const GradeType.vocabularyTest().id,
              ),
              gradeWith(
                value: 1.0,
                type: const GradeType.other().id,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .calculatedGrade!
              .asDouble,
          1);
    });
    test(
        'A subject can have a custom "Endnote" that overrides the terms "Endnote"',
        () {
      final controller = GradesTestController();

      final term = termWith(
        finalGradeType: const GradeType.writtenExam().id,
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            name: 'Philosophie',
            finalGradeType: const GradeType.vocabularyTest().id,
            grades: [
              gradeWith(
                value: 4.0,
                type: const GradeType.writtenExam().id,
              ),
              gradeWith(
                value: 2.0,
                type: const GradeType.vocabularyTest().id,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Philosophie'))
              .calculatedGrade!
              .asDouble,
          2.0);

      // Reset the finalGradeType for the subject
      controller.changeFinalGradeTypeForSubject(
        termId: term.id,
        subjectId: const SubjectId('Philosophie'),
        gradeType: null,
      );

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Philosophie'))
              .calculatedGrade!
              .asDouble,
          4.0);
    });
    test('A user can have several terms', () {
      final controller = GradesTestController();

      final term1 = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            name: 'Philosophie',
            grades: [
              gradeWith(value: 4.0),
            ],
          ),
        ],
      );
      controller.createTerm(term1);

      final term2 = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Sport'),
            name: 'Sport',
            grades: [
              gradeWith(value: 1.0),
            ],
          ),
        ],
      );
      controller.createTerm(term2);

      expect(controller.term(term1.id).calculatedGrade!.asDouble, 4.0);
      expect(controller.term(term2.id).calculatedGrade!.asDouble, 1.0);
    });
    test(
        'If a term is created with "Aktuelles Halbjahr" set to true, then terms with "Aktuelles Halbjahr" set to true will be set to false.',
        () {
      final controller = GradesTestController();

      final term1 = termWith(
        isActiveTerm: true,
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            name: 'Philosophie',
            grades: [
              gradeWith(value: 4.0),
            ],
          ),
        ],
      );
      controller.createTerm(term1);

      expect(controller.term(term1.id).isActiveTerm, true);

      final term2 = termWith(
        isActiveTerm: true,
        subjects: [
          subjectWith(
            id: const SubjectId('Sport'),
            name: 'Sport',
            grades: [
              gradeWith(value: 1.0),
            ],
          ),
        ],
      );
      controller.createTerm(term2);

      expect(controller.term(term1.id).isActiveTerm, false);
      expect(controller.term(term2.id).isActiveTerm, true);
    });
    test('A term can have a name.', () {
      final controller = GradesTestController();

      final term1 = termWith(name: '10/2');
      controller.createTerm(term1);

      expect(controller.term(term1.id).name, '10/2');
    });
    test('A term can have a grading system.', () {
      final controller = GradesTestController();

      final term1 =
          termWith(gradingSystem: GradingSystems.oneToSixWithPlusAndMinus);
      controller.createTerm(term1);

      expect(controller.term(term1.id).gradingSystem,
          GradingSystems.oneToSixWithPlusAndMinus);
    });
    test('Basic grades test for 1+ to 6 grading system.', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                // Equal to 1,75
                value: "2+",
                gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
              ),
              gradeWith(
                value: "3-",
                gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
              ),
              gradeWith(
                value: "2",
                gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
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
        gradingSystem: GradingSystems.oneToFiveteenPoints,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 4,
                gradingSystem: GradingSystems.oneToFiveteenPoints,
              ),
              gradeWith(
                value: 8,
                gradingSystem: GradingSystems.oneToFiveteenPoints,
              ),
              gradeWith(
                value: 2,
                gradingSystem: GradingSystems.oneToFiveteenPoints,
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
        gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            grades: [
              gradeWith(
                value: "3-", // Equal to 3.25
                gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
              ),
              // should be ignored in subject and terms calculated grade
              gradeWith(
                value: 3,
                gradingSystem: GradingSystems.oneToFiveteenPoints,
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
        gradingSystem: GradingSystems.oneToFiveteenPoints,
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            name: 'Mathe',
            grades: [
              gradeWith(
                value: 4,
                gradingSystem: GradingSystems.oneToFiveteenPoints,
              ),
              gradeWith(
                value: 8,
                gradingSystem: GradingSystems.oneToFiveteenPoints,
              ),
              gradeWith(
                // TODO: I accidentally passed 2 as a number and I don't think
                // it was processed correctly. I think this should've raised an
                // error, maybe not even in the test but in the logic code.
                value: "2+",
                gradingSystem: GradingSystems.oneToSixWithPlusAndMinus,
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

    // TODO: Using unknown GradeTypes in weight maps should do nothing (no error)
  });
}
