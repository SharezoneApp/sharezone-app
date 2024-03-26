// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:test_randomness/test_randomness.dart';

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
          throwsA(const UnknownGradeTypeException(GradeTypeId('test'))));
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
    // TODO: Using unknown GradeTypes in weight maps should do nothing (no error)
  });
}

class GradesTestController {
  final service = GradesService();

  void createTerm(TestTerm testTerm, {bool createMissingGradeTypes = false}) {
    final termId = testTerm.id;

    if (createMissingGradeTypes) {
      for (var id in _getAllGradeTypeIds(testTerm)) {
        service.createCustomGradeType(
          GradeType(id: id),
        );
      }
    }

    service.createTerm(
      id: termId,
      finalGradeType: testTerm.finalGradeType,
      isActiveTerm: testTerm.isActiveTerm,
      name: testTerm.name,
      gradingSystem: testTerm.gradingSystem,
    );

    if (testTerm.gradeTypeWeights != null) {
      for (var e in testTerm.gradeTypeWeights!.entries) {
        service.changeGradeTypeWeightForTerm(
          termId: termId,
          gradeType: e.key,
          weight: e.value,
        );
      }
    }

    for (var subject in testTerm.subjects.values) {
      service.addSubject(id: subject.id, toTerm: termId);
      if (subject.weight != null) {
        service.changeSubjectWeightForTermGrade(
            id: subject.id, termId: termId, weight: subject.weight!);
      }

      if (subject.weightType != null) {
        service.changeSubjectWeightTypeSettings(
            id: subject.id, termId: termId, perGradeType: subject.weightType!);
      }

      for (var e in subject.gradeTypeWeights.entries) {
        service.changeGradeTypeWeightForSubject(
            id: subject.id, termId: termId, gradeType: e.key, weight: e.value);
      }

      if (subject.finalGradeType != null) {
        service.changeSubjectFinalGradeType(
            id: subject.id, termId: termId, gradeType: subject.finalGradeType!);
      }

      for (var grade in subject.grades) {
        service.addGrade(
          id: subject.id,
          termId: termId,
          value: _toGrade(grade),
          takeIntoAccount: grade.includeInGradeCalculations,
        );
        if (grade.weight != null) {
          service.changeGradeWeight(
            id: grade.id,
            termId: termId,
            weight: grade.weight!,
          );
        }
      }
    }
  }

  IList<GradeTypeId> _getAllGradeTypeIds(TestTerm testTerm) {
    final ids = IList<GradeTypeId>()
        .add(testTerm.finalGradeType)
        .addAll(
          testTerm.gradeTypeWeights?.keys ?? [],
        )
        .addAll([
      for (var subject in testTerm.subjects.values)
        ..._getAllGradeTypeIdsForSubject(subject),
    ]);

    return ids;
  }

  IList<GradeTypeId> _getAllGradeTypeIdsForSubject(TestSubject testSubject) {
    return testSubject.gradeTypeWeights.keys
        .toIList()
        .addAll(testSubject.finalGradeType != null
            ? [testSubject.finalGradeType!]
            : [])
        .addAll(testSubject.grades.map((g) => g.type));
  }

  Grade _toGrade(TestGrade testGrade) {
    return Grade(
      id: testGrade.id,
      value: testGrade.value,
      gradingSystem: testGrade.gradingSystem,
      type: testGrade.type,
    );
  }

  TermResult term(TermId id) {
    final term = service.terms.value.singleWhere((t) => t.id == id);

    return term;
  }

  void changeWeightTypeForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required WeightType weightType}) {
    service.changeSubjectWeightTypeSettings(
        id: subjectId, termId: termId, perGradeType: weightType);
  }

  void changeGradeWeightsForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required Map<GradeId, Weight> weights}) {
    for (var e in weights.entries) {
      service.changeGradeWeight(
        id: e.key,
        termId: termId,
        weight: e.value,
      );
    }
  }

  void changeTermWeightsForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required Map<GradeTypeId, Weight> gradeTypeWeights}) {
    for (var e in gradeTypeWeights.entries) {
      service.changeGradeTypeWeightForSubject(
          id: subjectId, termId: termId, gradeType: e.key, weight: e.value);
    }
  }

  void changeFinalGradeTypeForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required GradeTypeId? gradeType}) {
    service.changeSubjectFinalGradeType(
        id: subjectId, termId: termId, gradeType: gradeType);
  }

  IList<GradeType> getPossibleGradeTypes() {
    return service.getPossibleGradeTypes();
  }

  void createCustomGradeType(GradeType gradeType) {
    return service.createCustomGradeType(gradeType);
  }

  void addGrade(
      {required TermId termId,
      required SubjectId subjectId,
      required TestGrade value}) {
    return service.addGrade(
      id: subjectId,
      termId: termId,
      value: _toGrade(value),
    );
  }
}

TestTerm termWith({
  TermId? id,
  String? name,
  List<TestSubject> subjects = const [],
  Map<GradeTypeId, Weight>? gradeTypeWeights,
  GradeTypeId finalGradeType = const GradeTypeId('Endnote'),
  bool isActiveTerm = true,
  GradingSystems? gradingSystem,
}) {
  final rdm = randomAlpha(5);
  final idd = id ?? TermId(rdm);
  return TestTerm(
    id: idd,
    name: name ?? '$idd',
    subjects: IMap.fromEntries(subjects.map((s) => MapEntry(s.id, s))),
    // TODO: Move default test grading system out and reference it from there
    // in the test code.
    gradingSystem: gradingSystem ?? GradingSystems.oneToFiveteenPoints,
    gradeTypeWeights: gradeTypeWeights,
    finalGradeType: finalGradeType,
    isActiveTerm: isActiveTerm,
  );
}

class TestTerm {
  final TermId id;
  final String name;
  final IMap<SubjectId, TestSubject> subjects;
  final GradingSystems gradingSystem;
  final Map<GradeTypeId, Weight>? gradeTypeWeights;
  final GradeTypeId finalGradeType;
  final bool isActiveTerm;

  TestTerm({
    required this.id,
    required this.name,
    required this.subjects,
    required this.finalGradeType,
    this.gradeTypeWeights,
    required this.isActiveTerm,
    required this.gradingSystem,
  });
}

TestSubject subjectWith({
  SubjectId? id,
  String? name,
  List<TestGrade> grades = const [],
  Weight? weight,
  WeightType? weightType,
  Map<GradeTypeId, Weight> gradeTypeWeights = const {},
  GradeTypeId? finalGradeType,
}) {
  final idd = id ?? SubjectId(randomAlpha(5));
  return TestSubject(
    id: idd,
    name: name ?? idd.id,
    grades: IList(grades),
    weight: weight,
    weightType: weightType,
    gradeTypeWeights: gradeTypeWeights,
    finalGradeType: finalGradeType,
  );
}

class TestSubject {
  final SubjectId id;
  final String name;
  final IList<TestGrade> grades;
  final WeightType? weightType;
  final Map<GradeTypeId, Weight> gradeTypeWeights;
  final Weight? weight;
  final GradeTypeId? finalGradeType;

  TestSubject({
    required this.id,
    required this.name,
    required this.grades,
    required this.gradeTypeWeights,
    this.weightType,
    this.weight,
    this.finalGradeType,
  }) : assert(() {
          // Help developers to not forget to set the weightType if
          // gradeTypeWeights or grade weights are set. This is not a hard
          // requirement by the logic, so if you need to do it anyways then you
          // might edit this assert.
          if (gradeTypeWeights.isNotEmpty) {
            return weightType == WeightType.perGradeType;
          }
          if (grades.any((g) => g.weight != null)) {
            return weightType == WeightType.perGrade;
          }

          return true;
        }());
}

TestGrade gradeWith({
  required Object value,
  bool includeInGradeCalculations = true,
  GradeTypeId? type,
  Weight? weight,
  GradeId? id,
  GradingSystems? gradingSystem,
}) {
  return TestGrade(
    id: id ?? GradeId(randomAlpha(5)),
    value: value,
    includeInGradeCalculations: includeInGradeCalculations,
    // TODO: Move default test grading system out and reference it from there
    // in the test code.
    gradingSystem: gradingSystem ?? GradingSystems.oneToFiveteenPoints,
    type: type ?? const GradeType.other().id,
    weight: weight,
  );
}

class TestGrade {
  final GradeId id;

  /// Either a [num] or [String]
  final Object value;
  final bool includeInGradeCalculations;
  final GradingSystems gradingSystem;
  final GradeTypeId type;
  final Weight? weight;

  TestGrade({
    required this.id,
    required this.value,
    required this.includeInGradeCalculations,
    required this.gradingSystem,
    required this.type,
    this.weight,
  }) {
    if (value is! num && value is! String) {
      throw ArgumentError.value(
        value,
        'value',
        'Must be a num or a String, but was ${value.runtimeType}',
      );
    }
  }
}
