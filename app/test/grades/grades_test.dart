// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:test_randomness/test_randomness.dart';

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
        'a subject will be added automatically to the term when setting the weight of a subject for a term',
        () {
      final controller = GradesTestController();

      final term = termWith();
      controller.createTerm(term);
      final subject =
          subjectWith(id: const SubjectId('Englisch'), name: 'Englisch');
      // This will add the subject to the list of available subjects but not to
      // a specific term.
      controller.addSubject(subject);

      void changeWeight() => controller.service
          .term(term.id)
          .subject(subject.id)
          .changeWeightForTermGrade(const Weight.factor(2));

      expect(changeWeight, returnsNormally);
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Englisch'))
              .weightingForTermGrade,
          const Weight.factor(2));
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
                  id: const GradeId('grade1'),
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
              .grade(const GradeId('grade1'))
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
                id: const GradeId('grade1'),
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
          const GradeId('grade1'): const Weight.percent(100),
        },
      );

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Sport'))
              .grade(const GradeId('grade1'))
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

      const presentation = GradeType.presentation;
      const exam = GradeType.writtenExam;
      const vocabularyTest = GradeType.vocabularyTest;

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
    test('Setting a grade weight to a negative number throws an $ArgumentError',
        () {
      final controller = GradesTestController();

      final term = termWith(
        id: const TermId('term1'),
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            weightType: WeightType.perGrade,
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                weight: const Weight.factor(0.2),
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.changeGradeWeightsForSubject(
          termId: const TermId('term1'),
          subjectId: const SubjectId('Mathe'),
          weights: {
            const GradeId('grade1'): const Weight.factor(-0.1),
          },
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    test(
        'Setting a grade type weight for a subject to a negative number throws an $ArgumentError',
        () {
      final controller = GradesTestController();

      final term = termWith(
        id: const TermId('term1'),
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            weightType: WeightType.perGradeType,
            gradeTypeWeights: {
              GradeType.presentation.id: const Weight.factor(1),
            },
            grades: [
              gradeWith(type: GradeType.presentation.id),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.changeTermWeightsForSubject(
          termId: const TermId('term1'),
          subjectId: const SubjectId('Mathe'),
          gradeTypeWeights: {
            GradeType.presentation.id: const Weight.factor(-0.1),
          },
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    test(
        'Setting a grade type weight for a term to a negative number throws an $ArgumentError',
        () {
      final controller = GradesTestController();

      final term = termWith(
        id: const TermId('term1'),
        gradeTypeWeights: {
          GradeType.presentation.id: const Weight.factor(1),
        },
        subjects: [
          subjectWith(
            grades: [
              gradeWith(type: GradeType.presentation.id, value: 1.0),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.changeGradeTypeWeightForTerm(
          termId: const TermId('term1'),
          gradeTypeWeights: {
            GradeType.presentation.id: const Weight.factor(-0.1),
          },
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    test(
        'Setting a subject weight for a term to a negative number throws an $ArgumentError',
        () {
      final controller = GradesTestController();

      final term = termWith(
        id: const TermId('term1'),
        subjects: [
          subjectWith(
            id: const SubjectId('Mathe'),
            grades: [gradeWith()],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.changeTermSubjectWeights(
          termId: const TermId('term1'),
          subjectWeights: {
            const SubjectId('Mathe'): const Weight.factor(-0.1),
          },
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    test(
        'grades for a subject will be weighted by the settings in term by default',
        () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation;
      const exam = GradeType.writtenExam;

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
      const grade1Id = GradeId('grade1');
      const grade2Id = GradeId('grade2');

      const presentation = GradeType.presentation;
      const exam = GradeType.writtenExam;

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
    test('a subject grade type can be removed from weighting', () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation;
      const exam = GradeType.writtenExam;

      final term = termWith(
        gradeTypeWeights: {
          presentation.id: const Weight.factor(1),
          exam.id: const Weight.factor(3),
        },
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

      controller.removeWeightTypeForSubject(
        termId: term.id,
        subjectId: const SubjectId('Deutsch'),
        gradeTypeId: presentation.id,
      );

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .gradeTypeWeights
              .keys,
          [exam.id]);
    });
    test(
        'A term has ${WeightDisplayType.factor} as a default weight display type',
        () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('term1'),
          subjects: [
            subjectWith(
              id: const SubjectId('Deutsch'),
              abbreviation: 'D',
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
      );

      expect(controller.term(const TermId('term1')).weightDisplayType,
          WeightDisplayType.factor);
    });
    test('The weight display type of a term can be changed', () {
      final controller = GradesTestController();

      controller.createTerms([
        termWith(
          id: const TermId('term1'),
          weightDisplayType: WeightDisplayType.factor,
          subjects: [
            subjectWith(
              id: const SubjectId('Deutsch'),
              abbreviation: 'D',
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
      ]);

      controller.changeWeightDisplayTypeForTerm(
        termId: const TermId('term1'),
        weightDisplayType: WeightDisplayType.percent,
      );

      expect(controller.term(const TermId('term1')).weightDisplayType,
          WeightDisplayType.percent);

      controller.changeWeightDisplayTypeForTerm(
        termId: const TermId('term1'),
        weightDisplayType: WeightDisplayType.factor,
      );

      expect(controller.term(const TermId('term1')).weightDisplayType,
          WeightDisplayType.factor);
    });
    test(
        'When changing weight display type for one term then it doesnt affect the type of the other terms',
        () {
      final controller = GradesTestController();

      controller.createTerms([
        termWith(
          id: const TermId('term1'),
          weightDisplayType: WeightDisplayType.factor,
          subjects: [
            subjectWith(
              id: const SubjectId('Deutsch'),
              abbreviation: 'D',
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
        termWith(
          id: const TermId('term2'),
          weightDisplayType: WeightDisplayType.factor,
          subjects: [
            subjectWith(
              id: const SubjectId('Englisch'),
              abbreviation: 'E',
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
      ]);

      controller.changeWeightDisplayTypeForTerm(
        termId: const TermId('term1'),
        weightDisplayType: WeightDisplayType.percent,
      );

      expect(controller.term(const TermId('term2')).weightDisplayType,
          WeightDisplayType.factor);
    });
    test('a grade type weight can be remove from term', () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation;
      const exam = GradeType.writtenExam;

      final term = termWith(
        gradeTypeWeights: {
          presentation.id: const Weight.factor(1),
          exam.id: const Weight.factor(3),
        },
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

      controller.removeGradeTypeWeightForTerm(
        termId: term.id,
        gradeTypeId: presentation.id,
      );

      expect(controller.term(term.id).gradeTypeWeightings.keys, [exam.id]);
    });
    test(
        'a subjects gradeType weights are saved even when they are deactivated',
        () {
      final controller = GradesTestController();

      const presentation = GradeType.presentation;
      const exam = GradeType.writtenExam;

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
    test(
        'If a term is added with an unknown final grade type then an $GradeTypeNotFoundException is thrown',
        () {
      final controller = GradesTestController();

      final term = termWith(finalGradeType: const GradeTypeId('foo'));
      expect(
        () => controller.createTerm(term, createMissingGradeTypes: false),
        throwsA(const GradeTypeNotFoundException(GradeTypeId('foo'))),
      );
    });
    test('The "Endnote" grade type overrides the subject grade', () {
      final controller = GradesTestController();

      final term = termWith(
        finalGradeType: GradeType.other.id,
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [
              gradeWith(
                value: 3.0,
                type: GradeType.vocabularyTest.id,
              ),
              gradeWith(
                value: 1.0,
                type: GradeType.other.id,
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
    test('A grade saves the original input', () {
      final controller = GradesTestController();

      final term = termWith(
        gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [
              gradeWith(
                  id: const GradeId('grade1'),
                  value: "2+",
                  gradingSystem: GradingSystem.oneToSixWithPlusAndMinus),
              gradeWith(
                  id: const GradeId('grade2'),
                  value: 1.75,
                  gradingSystem: GradingSystem.oneToSixWithPlusAndMinus),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .grade(const GradeId('grade1'))
              .originalInput,
          '2+');
      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Deutsch'))
              .grade(const GradeId('grade2'))
              .originalInput,
          1.75);
    });
    test(
        'A subject can have a custom "Endnote" that overrides the terms "Endnote"',
        () {
      final controller = GradesTestController();

      final term = termWith(
        finalGradeType: GradeType.writtenExam.id,
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            name: 'Philosophie',
            finalGradeType: GradeType.vocabularyTest.id,
            grades: [
              gradeWith(
                value: 4.0,
                type: GradeType.writtenExam.id,
              ),
              gradeWith(
                value: 2.0,
                type: GradeType.vocabularyTest.id,
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
    test('Its possible that no terms are active', () {
      final controller = GradesTestController();

      final term1 = termWith(isActiveTerm: false);
      final term2 = termWith(isActiveTerm: false);
      controller.createTerm(term1);
      controller.createTerm(term2);

      // Just making sure that no exception is thrown
      controller.editTerm(term1.id, isActiveTerm: true);
      controller.editTerm(term1.id, isActiveTerm: false);

      expect(controller.terms, hasLength(2));
      expect(
          controller.terms,
          everyElement(predicate<TermResult>(
              (p0) => p0.isActiveTerm == false, 'is not active')));
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
    test(
        'If a term is edited with "Aktuelles Halbjahr" set to true, then terms with "Aktuelles Halbjahr" set to true will be set to false.',
        () {
      final controller = GradesTestController();

      final term1 = termWith(isActiveTerm: true);
      final term2 = termWith(isActiveTerm: false);
      controller.createTerm(term1);
      controller.createTerm(term2);

      controller.editTerm(term2.id, isActiveTerm: true);

      expect(controller.term(term1.id).isActiveTerm, false);
      expect(controller.term(term2.id).isActiveTerm, true);
    });
    test(
        'If a term is edited with "Aktuelles Halbjahr" set to false, then "Aktuelles Halbjahr" will be set to false.',
        () {
      final controller = GradesTestController();

      final term1 = termWith(isActiveTerm: true);
      controller.createTerm(term1);

      controller.editTerm(term1.id, isActiveTerm: false);

      expect(controller.term(term1.id).isActiveTerm, false);
    });
    test(
        'Setting "Aktuelles Halbjahr" false on a term where "Aktuelles Halbjahr" is already to false won\'t alter the other terms.',
        () {
      final controller = GradesTestController();

      final term1 = termWith(isActiveTerm: true);
      final term2 = termWith(isActiveTerm: false);
      controller.createTerm(term1);
      controller.createTerm(term2);

      // Is already false
      controller.editTerm(term2.id, isActiveTerm: false);

      // term1 should still be active
      expect(controller.term(term1.id).isActiveTerm, true);
    });
    test(
        'If the final grade type of the term is edited then the new value will be used.',
        () {
      final controller = GradesTestController();

      final term1 = termWith(finalGradeType: GradeType.other.id);
      controller.createTerm(term1);

      controller.editTerm(term1.id, finalGradeType: GradeType.writtenExam.id);

      expect(controller.term(term1.id).finalGradeType, GradeType.writtenExam);
    });
    test(
        'If the final grade type of a term is edited to a unknown grade type then a $GradeTypeNotFoundException will be thrown',
        () {
      final controller = GradesTestController();

      final term1 = termWith(finalGradeType: GradeType.other.id);
      controller.createTerm(term1);

      expect(
        () => controller.editTerm(term1.id,
            finalGradeType: const GradeTypeId('foo')),
        throwsA(const GradeTypeNotFoundException(GradeTypeId('foo'))),
      );
    });
    test(
        'If the grading system of the term is edited then the new value will be used for the term.',
        () {
      final controller = GradesTestController();

      final term = termWith(
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals);
      controller.createTerm(term);

      controller.editTerm(term.id,
          gradingSystem: GradingSystem.oneToSixWithPlusAndMinus);

      expect(controller.term(term.id).gradingSystem,
          GradingSystem.oneToSixWithPlusAndMinus);
    });

    test('Nothing happens if a term is edited with blank values', () {
      final controller = GradesTestController();

      final term1 = termWith(
        isActiveTerm: true,
        finalGradeType: GradeType.other.id,
        name: 'Foo',
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
      final term2 = termWith(
        isActiveTerm: false,
        finalGradeType: GradeType.writtenExam.id,
        name: 'Bar',
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
      controller.createTerm(term1);
      controller.createTerm(term2);

      final t1 = controller.term(term1.id);
      final t2 = controller.term(term2.id);

      // Do nothing
      controller.editTerm(term1.id);
      controller.editTerm(term2.id);

      // Nothing should've changed
      expect(controller.term(term1.id), t1);
      expect(controller.term(term2.id), t2);
    });
    test('A term can have a name.', () {
      final controller = GradesTestController();

      final term1 = termWith(name: '10/2');
      controller.createTerm(term1);

      expect(controller.term(term1.id).name, '10/2');
    });
    test('The name of the term can be edited', () {
      final controller = GradesTestController();

      final term1 = termWith(name: 'foo');
      controller.createTerm(term1);

      controller.editTerm(term1.id, name: 'bar');

      expect(controller.term(term1.id).name, 'bar');
    });
    test('Deleting a term will delete all grades inside it, but no subjects',
        () {
      final controller = GradesTestController();

      final term1 = termWith(subjects: [
        subjectWith(
          id: const SubjectId('Sport'),
          name: 'Sport',
          grades: [gradeWith(value: 1.0)],
        ),
      ]);
      final term2 = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            name: 'Philosophie',
            grades: [gradeWith(value: 4.0)],
          ),
        ],
      );

      controller.createTerm(term1);
      controller.createTerm(term2);

      controller.deleteTerm(term1.id);

      expect(controller.getSubjects().map((sub) => sub.id), [
        const SubjectId('Sport'),
        const SubjectId('Philosophie'),
      ]);
      expect(controller.terms.single.id, term2.id);
    });
    test('Deleting an unknown term will throw an ArgumentError', () {
      final controller = GradesTestController();

      expect(() => controller.deleteTerm(const TermId('foo')),
          throwsA(isA<ArgumentError>()));
    });
    test('A grade has a Date', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                value: 4.0,
                date: Date.fromDateTime(DateTime(2024, 03, 26)),
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
              .grade(const GradeId('grade1'))
              .date,
          Date('2024-03-26'));
    });
    test('A grade and GradeValue has a gradingSystem', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                gradingSystem: GradingSystem.oneToFiveWithDecimals,
                value: 2.5,
              ),
              gradeWith(
                id: const GradeId('grade2'),
                gradingSystem: GradingSystem.sixToOneWithDecimals,
                value: 4.2,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      final grade1 = controller
          .term(term.id)
          .subject(const SubjectId('Philosophie'))
          .grade(const GradeId('grade1'));
      // On both since the calculated averageGrade is only a [GradeValue], not a [GradeResult].
      expect(grade1.gradingSystem, GradingSystem.oneToFiveWithDecimals);
      expect(grade1.value.gradingSystem, GradingSystem.oneToFiveWithDecimals);

      final grade2 = controller
          .term(term.id)
          .subject(const SubjectId('Philosophie'))
          .grade(const GradeId('grade2'));
      expect(grade2.gradingSystem, GradingSystem.sixToOneWithDecimals);
      expect(grade2.value.gradingSystem, GradingSystem.sixToOneWithDecimals);
    });
    test('A grade can be deleted', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                value: 4.0,
              ),
              gradeWith(
                id: const GradeId('grade2'),
                value: 4.5,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      controller.deleteGrade(gradeId: const GradeId('grade1'));

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Philosophie'))
              .grades,
          hasLength(1));

      expect(
          controller
              .term(term.id)
              .subject(const SubjectId('Philosophie'))
              .grades
              .single
              .id,
          const GradeId('grade2'));
    });
    test(
        'Trying to edit a grade with an unknown Id will throw $GradeNotFoundException',
        () {
      final controller = GradesTestController();

      edit() => controller.editGrade(gradeWith(id: const GradeId('foo')));

      expect(edit, throwsA(const GradeNotFoundException(GradeId('foo'))));
    });
    test('A grade can be edited', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(id: const GradeId('grade1')),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      controller.editGrade(
        gradeWith(
          id: const GradeId('grade1'),
          date: Date('2024-03-22'),
          details: 'foo details',
          includeInGradeCalculations: false,
          title: 'foo title',
          type: GradeType.other.id,
          gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
          value: '23',
        ),
      );

      final actualGrade = controller
          .term(term.id)
          .subject(const SubjectId('Philosophie'))
          .grade(const GradeId('grade1'));

      expect(
        actualGrade,
        GradeResult(
          id: const GradeId('grade1'),
          isTakenIntoAccount: false,
          value: const GradeValue(
            asNum: 23,
            displayableGrade: null,
            gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
            suffix: '%',
          ),
          date: Date('2024-03-22'),
          title: 'foo title',
          gradeTypeId: GradeType.other.id,
          details: 'foo details',
          originalInput: '23',
        ),
      );
    });
    test(
        'If the edited grade has an unknown grade type a $GradeTypeNotFoundException is thrown',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(id: const GradeId('grade1')),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.editGrade(
          gradeWith(
            id: const GradeId('grade1'),
            type: const GradeTypeId('foo'),
          ),
        ),
        throwsA(const GradeTypeNotFoundException(GradeTypeId('foo'))),
      );
    });
    test(
        'If the edited grade has an invalid grade value a $InvalidGradeValueException is thrown',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(id: const GradeId('grade1')),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.editGrade(
          gradeWith(
            id: const GradeId('grade1'),
            gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
            value: '8+',
          ),
        ),
        throwsA(const InvalidGradeValueException(
          gradeInput: '8+',
          gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
        )),
      );
    });
    test(
        'When trying to add a grade with the same id as an existing grade then a $DuplicateGradeIdException is thrown',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                value: 4.0,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.addGrade(
          termId: term.id,
          subjectId: const SubjectId('Philosophie'),
          value: gradeWith(
            id: const GradeId('grade1'),
            value: 4.0,
          ),
        ),
        throwsA(const DuplicateGradeIdException(GradeId('grade1'))),
      );
    });
    test(
        'If an unknown grade is to be deleted then an $GradeNotFoundException will be thrown',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                value: 4.0,
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
        () => controller.deleteGrade(
          gradeId: const GradeId('unknown'),
        ),
        throwsA(const GradeNotFoundException(GradeId('unknown'))),
      );
    });
    test('A grade has a title', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                value: 4.0,
                title: 'Klausur',
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
              .grade(const GradeId('grade1'))
              .title,
          'Klausur');
    });
    test('A grade has details', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: const GradeId('grade1'),
                value: 4.0,
                details: 'my details',
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
              .grade(const GradeId('grade1'))
              .details,
          'my details');
    });

    test('A subject has a Design', () {
      final controller = GradesTestController();

      final design = Design.random(szTestRandom);
      controller.createTerm(
        termWith(
          id: const TermId('term1'),
          subjects: [
            subjectWith(
              name: 'Deutsch', design: design,
              // Subject is implicitly added to term when grade is added.
              // So to be able to call term(id).subjects.single we need this
              // grade otherwise term(id).subjects would be empty
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
      );

      final subject = controller.getSubjects().single;
      expect(subject.design, design);
      final subject2 = controller.term(const TermId('term1')).subjects.single;
      expect(subject2.design, design);
    });
    test('A subject has a name and abbreviation', () {
      final controller = GradesTestController();

      controller.createTerm(
        termWith(
          id: const TermId('term1'),
          subjects: [
            subjectWith(
              name: 'Deutsch',
              abbreviation: 'D',
              // Subject is implicitly added to term when grade is added.
              // So to be able to call term(id).subjects.single we need this
              // grade otherwise term(id).subjects would be empty
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
      );

      var subject = controller.getSubjects().single;
      expect(subject.name, 'Deutsch');
      expect(subject.abbreviation, 'D');
      final subject2 = controller.term(const TermId('term1')).subjects.single;
      expect(subject2.name, 'Deutsch');
      expect(subject2.abbreviation, 'D');
    });
    test('A subject has connected courses', () {
      final controller = GradesTestController();

      final connectedCourses = [
        const ConnectedCourse(
          id: CourseId('course1'),
          name: 'Course 1',
          subjectName: 'Deutsch',
          abbreviation: 'D',
        ),
        const ConnectedCourse(
          id: CourseId('course2'),
          name: 'Course 2',
          subjectName: 'deutsch',
          abbreviation: 'DE',
        ),
      ];

      controller.createTerm(
        termWith(
          id: const TermId('term1'),
          subjects: [
            subjectWith(
              id: const SubjectId('Deutsch'),
              abbreviation: 'D',
              connectedCourses: connectedCourses,
              grades: [gradeWith(value: 2)],
            ),
          ],
        ),
      );

      var subject = controller.getSubjects().single;
      expect(subject.connectedCourses, connectedCourses);
      final subject2 = controller
          .term(const TermId('term1'))
          .subject(const SubjectId('Deutsch'));
      expect(subject2.connectedCourses, connectedCourses);
    });
    test(
        'If a subject with the same id is already existing a $SubjectAlreadyExistsException exception will be thrown and the subject will not be added.',
        () {
      final controller = GradesTestController();

      // Two different subject with the same id to make sure that the id, not
      // the object itself is checked.
      final subject1 =
          subjectWith(id: const SubjectId('Mathe'), name: 'Mathe 1');
      final subject2 =
          subjectWith(id: const SubjectId('Mathe'), name: 'Mathe 2');
      controller.addSubject(subject1);

      expect(
        () => controller.addSubject(subject2),
        throwsA(const SubjectAlreadyExistsException(SubjectId('Mathe'))),
      );
      // We check the design to know that the first subject was added.
      expect(controller.getSubjects().single.name, 'Mathe 1');
    });
    test(
        'If a grade with an unknown subject id was added then a $SubjectNotFoundException is thrown',
        () {
      final controller = GradesTestController();

      controller.createTerm(termWith(id: const TermId('term1')));
      addGrade() => controller.addGrade(
            termId: const TermId('term1'),
            subjectId: const SubjectId('Unknown'),
            value: gradeWith(value: '3'),
          );

      expect(addGrade,
          throwsA(const SubjectNotFoundException(SubjectId('Unknown'))));
    });
  });
  test(
      'Regression test: Changing the final grade type of a term shouldnt delete any subjects',
      () {
    final controller = GradesTestController();

    controller.createTerm(
      termWith(
        id: const TermId('term1'),
        finalGradeType: GradeType.other.id,
        subjects: [
          subjectWith(
            id: const SubjectId('Deutsch'),
            finalGradeType: GradeType.vocabularyTest.id,
            grades: [gradeWith(value: 2)],
          ),
          subjectWith(
            id: const SubjectId('Sport'),
            grades: [gradeWith(value: 2)],
          ),
        ],
      ),
    );

    // This would delete any subject with no overridden final grade type before
    // fixing the bug.
    controller.editTerm(
      const TermId('term1'),
      finalGradeType: GradeType.vocabularyTest.id,
    );

    expect(
        controller
            .term(const TermId('term1'))
            .subjects
            .map((sub) => sub.id)
            .toList(),
        [
          const SubjectId('Deutsch'),
          const SubjectId('Sport'),
        ]);
  });
}
