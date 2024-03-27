// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
      final grade1Id = GradeId('grade1');
      final grade2Id = GradeId('grade2');

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
                type: GradeType.presentation.id,
                weight: const Weight.factor(1),
              ),
              gradeWith(
                value: 1.0,
                type: GradeType.writtenExam.id,
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
    test('A grade has a Date', () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: const SubjectId('Philosophie'),
            grades: [
              gradeWith(
                id: GradeId('grade1'),
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
              .grade(GradeId('grade1'))
              .date,
          Date('2024-03-26'));
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
}
