// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:date/date.dart';
import 'package:clock/clock.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';

import '../../grades_test_common.dart';

class MockCrashAnalytics extends Mock implements CrashAnalytics {}

class MockAnalytics extends Mock implements Analytics {}

void main() {
  group('$GradesDialogController', () {
    late GradesTestController gradesTestController;
    late GradesService gradesService;
    late CrashAnalytics crashAnalytics;
    late Analytics analytics;
    late GradesDialogController controller;

    GradesDialogController createController({GradeId? gradeId}) {
      return GradesDialogController(
        gradesService: gradesService,
        coursesStream: Stream.value([]),
        crashAnalytics: crashAnalytics,
        analytics: analytics,
        gradeId: gradeId,
      );
    }

    setUp(() {
      gradesService = GradesService();
      gradesTestController = GradesTestController(gradesService: gradesService);
      crashAnalytics = MockCrashAnalytics();
      analytics = MockAnalytics();
      controller = createController();
    });

    group('editing', () {
      test('error is thrown if subject is tried to be changed', () {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('foo'),
            name: 'Foo term',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('maths'),
                name: 'Maths',
                grades: [gradeWith(id: const GradeId('grade1'))],
              ),
              subjectWith(
                id: const SubjectId('english'),
                name: 'english',
                grades: [gradeWith(id: const GradeId('grade2'))],
              ),
            ],
          ),
        );

        controller = createController(gradeId: const GradeId('grade1'));

        expect(
          () => controller.setSubject(const SubjectId('english')),
          throwsA(isA<UnsupportedError>()),
        );
      });
      test('error is thrown if term is tried to be changed', () {
        gradesTestController.createTerms([
          termWith(
            id: const TermId('foo'),
            name: 'Foo term',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('maths'),
                name: 'Maths',
                grades: [gradeWith(id: const GradeId('grade1'))],
              ),
            ],
          ),
          termWith(id: const TermId('bar'), name: 'Bar term'),
        ]);

        controller = createController(gradeId: const GradeId('grade1'));

        expect(
          () => controller.setTerm(const TermId('bar')),
          throwsA(isA<UnsupportedError>()),
        );
      });
      test('term and subject fields are deactivated in view', () {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('foo'),
            name: 'Foo term',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('maths'),
                name: 'Maths',
                grades: [gradeWith(id: const GradeId('grade1'))],
              ),
            ],
          ),
        );

        controller = createController(gradeId: const GradeId('grade1'));

        expect(controller.view.isSubjectFieldDisabled, true);
        expect(controller.view.isTermFieldDisabled, true);
      });
      test('changes to grade are correctly applied', () async {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('foo'),
            name: 'Foo term',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('german'),
                name: 'German',
                grades: [
                  gradeWith(
                    id: const GradeId('grade1'),
                    title: 'Analysis of Goethe',
                    gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
                    type: GradeType.oralParticipation.id,
                    includeInGradeCalculations: false,
                    value: '2-',
                    date: Date("2025-02-21"),
                    details: 'Notes',
                  ),
                ],
              ),
            ],
          ),
        );

        controller = createController(gradeId: const GradeId('grade1'));

        controller.setTitle('Analysis of Schiller');
        controller.setGradingSystem(GradingSystem.oneToSixWithDecimals);
        controller.setGrade('2.25');
        controller.setDate(Date("2025-02-22"));
        controller.setDetails('Analysis of Schillers Book "Die Räuber"');
        controller.setGradeType(GradeType.presentation);
        controller.setIntegrateGradeIntoSubjectGrade(true);

        await controller.save();

        final grade = gradesTestController
            .term(const TermId('foo'))
            .subject(const SubjectId('german'))
            .grade(const GradeId('grade1'));

        expect(grade.title, 'Analysis of Schiller');
        expect(grade.gradingSystem, GradingSystem.oneToSixWithDecimals);
        expect(grade.value.asNum, 2.25);
        expect(grade.date, Date("2025-02-22"));
        expect(grade.gradeTypeId, GradeType.presentation.id);
        expect(grade.isTakenIntoAccount, true);
        expect(grade.details, 'Analysis of Schillers Book "Die Räuber"');
      });
      test(
        'if a grade id is passed then the data of the grade will be prefilled',
        () {
          gradesTestController.createTerm(
            termWith(
              id: const TermId('foo'),
              name: 'Foo term',
              gradingSystem: GradingSystem.zeroToFifteenPoints,
              subjects: [
                subjectWith(
                  id: const SubjectId('maths'),
                  name: 'Maths',
                  grades: [
                    gradeWith(
                      id: const GradeId('grade1'),
                      title: 'Foo',
                      gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
                      includeInGradeCalculations: false,
                      type: GradeType.presentation.id,
                      value: '2-',
                      date: Date("2025-02-21"),
                      details: 'Notes',
                    ),
                  ],
                ),
              ],
            ),
          );

          controller = createController(gradeId: const GradeId('grade1'));

          expect(controller.view.title, 'Foo');
          expect(controller.view.selectedGrade, '2-');
          expect(
            controller.view.selectedGradingSystem,
            GradingSystem.oneToSixWithPlusAndMinus,
          );
          expect(controller.view.selectedDate, Date("2025-02-21"));
          expect(controller.view.selectedGradingType, GradeType.presentation);
          expect(controller.view.takeIntoAccount, false);
          expect(controller.view.detailsController.text, 'Notes');
          expect(controller.view.selectedSubject, (
            id: const SubjectId('maths'),
            name: 'Maths',
          ));
          expect(controller.view.selectedTerm, (
            id: const TermId('foo'),
            name: 'Foo term',
          ));

          expect(controller.view.titleErrorText, null);
          expect(controller.view.selectedGradeErrorText, null);
          expect(controller.view.isGradeMissing, false);
          expect(controller.view.isSubjectMissing, false);
          expect(controller.view.isTermMissing, false);
          expect(controller.view.isGradeTypeMissing, false);

          gradesTestController.addGrade(
            termId: const TermId('foo'),
            subjectId: const SubjectId('maths'),
            value: gradeWith(
              id: const GradeId('grade2'),
              gradingSystem: GradingSystem.zeroToFifteenPointsWithDecimals,
              includeInGradeCalculations: true,
              value: 13.2,
            ),
          );

          controller = createController(gradeId: const GradeId('grade2'));

          expect(controller.view.selectedGrade, '13,2');
          expect(
            controller.view.selectedGradingSystem,
            GradingSystem.zeroToFifteenPointsWithDecimals,
          );
          expect(controller.view.takeIntoAccount, true);
        },
      );
    });

    group('Initialization and defaults', () {
      test('the default date is the current day', () {
        withClock(Clock.fixed(DateTime(2025, 02, 21)), () {
          controller = createController();
          expect(controller.view.selectedDate, Date("2025-02-21"));
        });
      });

      test(
        'if there is an active term then it is the default value for the selected term',
        () {
          gradesTestController.createTerm(
            termWith(id: const TermId('foo'), name: "Foo term"),
          );

          controller = createController();

          expect(controller.view.selectedTerm, (
            id: const TermId('foo'),
            name: "Foo term",
          ));
        },
      );

      test(
        'if there is an active term then its grading system is the default value',
        () {
          gradesTestController.createTerm(
            termWith(gradingSystem: GradingSystem.zeroToFifteenPoints),
          );

          controller = createController();

          expect(
            controller.view.selectedGradingSystem,
            (GradingSystem.zeroToFifteenPoints),
          );
        },
      );

      test(
        'if there is no active term then the default $GradingSystem is ${GradingSystem.oneToSixWithPlusAndMinus}',
        () {
          expect(
            controller.view.selectedGradingSystem,
            GradingSystem.oneToSixWithPlusAndMinus,
          );
        },
      );

      test('$TakeIntoAccountState is enabled by default', () {
        controller = createController();
        expect(
          controller.view.takeIntoAccountState,
          TakeIntoAccountState.enabled,
        );
      });
    });

    group('Field setters', () {
      test('setting multiple fields updates the view', () {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('foo'),
            name: 'Foo term',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('maths'),
                name: 'Maths',
                grades: [gradeWith()],
              ),
            ],
          ),
        );

        controller = createController();

        // Test settings grading system
        controller.setGradingSystem(GradingSystem.oneToSixWithPlusAndMinus);
        expect(
          controller.view.selectedGradingSystem,
          GradingSystem.oneToSixWithPlusAndMinus,
        );

        // Test setting grade
        controller.setGrade('1');
        expect(controller.view.selectedGrade, '1');
        expect(controller.view.selectedGradeErrorText, null);

        // Test setting subject
        controller.setSubject(const SubjectId('maths'));
        expect(controller.view.selectedSubject?.name, 'Maths');
        expect(controller.view.isSubjectMissing, false);
        expect(controller.view.isSubjectFieldDisabled, false);

        // Test setting term
        controller.setTerm(const TermId('foo'));
        expect(controller.view.selectedTerm?.name, 'Foo term');
        expect(controller.view.isTermMissing, false);
        expect(controller.view.isTermFieldDisabled, false);

        // Test setting date
        controller.setDate(Date("2025-02-21"));
        expect(controller.view.selectedDate, Date("2025-02-21"));

        // Test setting grade type
        controller.setGradeType(GradeType.presentation);
        expect(controller.view.selectedGradingType, GradeType.presentation);
        expect(controller.view.isGradeTypeMissing, false);

        // Test setting title
        controller.setTitle('Test Title');
        expect(controller.view.title, 'Test Title');
        expect(controller.view.titleErrorText, null);

        // Test take into account flag
        controller.setIntegrateGradeIntoSubjectGrade(false);
        expect(controller.view.takeIntoAccount, false);
      });
    });

    group('Grade handling', () {
      test('setting invalid grade shows error', () {
        controller.setGradingSystem(
          GradingSystem.zeroToFifteenPointsWithDecimals,
        );

        controller.setGrade('13,,2,3,3');
        expect(
          controller.view.selectedGradeErrorText,
          'Die Eingabe ist keine gültige Zahl.',
        );

        controller.setGrade('');
        expect(
          controller.view.selectedGradeErrorText,
          'Bitte eine Note eingeben.',
        );
      });

      test('resetting grade system clears grade value', () {
        controller = createController();

        controller.setGrade('1');
        expect(controller.view.selectedGrade, '1');

        controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);
        expect(controller.view.selectedGrade, null);
      });

      test(
        'setGradingSystem only notifies listeners when system changes and grade is preserved',
        () {
          // Set initial grading system and a grade value
          controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);
          controller.setGrade('10');

          final initialSystem = controller.view.selectedGradingSystem;
          final initialGrade = controller.view.selectedGrade;

          // Setting the same system shouldn't trigger change or reset grade
          controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);

          expect(controller.view.selectedGradingSystem, initialSystem);
          expect(
            controller.view.selectedGrade,
            initialGrade,
            reason:
                'Grade should not be reset when setting the same grading system',
          );
        },
      );

      test('setting grade with valid input clears error text', () {
        controller.setGradingSystem(
          GradingSystem.zeroToFifteenPointsWithDecimals,
        );

        controller.setGrade('invalid');
        expect(controller.view.selectedGradeErrorText, isNotNull);

        controller.setGrade('12.5');
        expect(controller.view.selectedGradeErrorText, isNull);
      });
    });

    group('Term interaction', () {
      test('changing term updates grading system if no grade entered', () {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('term1'),
            gradingSystem: GradingSystem.zeroToFifteenPoints,
          ),
        );

        controller = createController();
        controller.setTerm(const TermId('term1'));

        expect(
          controller.view.selectedGradingSystem,
          GradingSystem.zeroToFifteenPoints,
        );
      });

      test(
        'changing term preserves grading system if grade already entered',
        () {
          gradesTestController.createTerms([
            termWith(
              id: const TermId('term1'),
              gradingSystem: GradingSystem.zeroToFifteenPoints,
            ),
            termWith(
              id: const TermId('term2'),
              gradingSystem: GradingSystem.oneToFiveWithDecimals,
            ),
          ]);
          controller = createController();

          controller.setTerm(const TermId('term1'));
          controller.setGrade('8');
          controller.setTerm(const TermId('term2'));

          expect(
            controller.view.selectedGradingSystem,
            GradingSystem.zeroToFifteenPoints,
          );
        },
      );
    });

    group('Title handling', () {
      test('changing grade type updates title if empty', () {
        controller = createController();

        controller.setGradeType(GradeType.presentation);
        expect(
          controller.view.title,
          GradeType.presentation.predefinedType?.toUiString(),
        );
      });

      test('changing grade type preserves custom title', () {
        controller = createController();

        controller.setTitle('Custom Title');
        controller.setGradeType(GradeType.presentation);
        expect(controller.view.title, 'Custom Title');
      });

      test('title error text is shown when title is empty', () {
        controller.setTitle('');
        expect(controller.view.titleErrorText, 'Bitte einen Titel eingeben.');

        controller.setTitle('Valid Title');
        expect(controller.view.titleErrorText, null);
      });

      test(
        'changing grade type when title matches previous grade type updates title',
        () {
          controller = createController();

          // Set initial grade type and verify title is set
          controller.setGradeType(GradeType.oralParticipation);
          final initialTitle = controller.view.title;

          // Change to new grade type, title should update
          controller.setGradeType(GradeType.presentation);
          expect(controller.view.title, isNot(equals(initialTitle)));
          expect(
            controller.view.title,
            GradeType.presentation.predefinedType?.toUiString(),
          );
        },
      );
    });

    group('Take into account state', () {
      test(
        '$TakeIntoAccountState is ${TakeIntoAccountState.disabledWrongGradingSystem} when grade type has weight of zero',
        () {
          gradesTestController.createTerm(
            termWith(
              gradeTypeWeights: {GradeType.presentation.id: Weight.zero},
              subjects: [
                subjectWith(
                  id: const SubjectId('maths'),
                  grades: [gradeWith()],
                ),
              ],
            ),
          );

          controller = createController();
          controller.setSubject(const SubjectId('maths'));
          controller.setGradeType(GradeType.presentation);

          expect(
            controller.view.takeIntoAccountState,
            TakeIntoAccountState.disabledGradeTypeWithNoWeight,
          );
        },
      );
      test(
        '$TakeIntoAccountState is ${TakeIntoAccountState.disabledWrongGradingSystem} when grade type has weight of zero (when editing grade)',
        () {
          gradesTestController.createTerm(
            termWith(
              gradeTypeWeights: {GradeType.presentation.id: Weight.zero},
              subjects: [
                subjectWith(
                  id: const SubjectId('maths'),
                  grades: [
                    gradeWith(
                      id: const GradeId('grade1'),
                      type: GradeType.writtenExam.id,
                    ),
                  ],
                ),
              ],
            ),
          );

          controller = createController(gradeId: const GradeId('grade1'));

          controller.setGradeType(GradeType.presentation);

          expect(
            controller.view.takeIntoAccountState,
            TakeIntoAccountState.disabledGradeTypeWithNoWeight,
          );
        },
      );

      test(
        '$TakeIntoAccountState is ${TakeIntoAccountState.disabledWrongGradingSystem} when term and selected grading systems differ',
        () {
          gradesTestController.createTerm(
            termWith(gradingSystem: GradingSystem.zeroToFifteenPoints),
          );
          controller = createController();
          controller.setGradingSystem(GradingSystem.oneToSixWithPlusAndMinus);

          expect(
            controller.view.takeIntoAccountState,
            TakeIntoAccountState.disabledWrongGradingSystem,
          );
        },
      );

      test(
        '$TakeIntoAccountState is ${TakeIntoAccountState.disabledWrongGradingSystem} when term and selected grading systems differ (when editing grade)',
        () {
          gradesTestController.createTerm(
            termWith(
              gradingSystem: GradingSystem.zeroToFifteenPoints,
              subjects: [
                subjectWith(
                  id: const SubjectId('maths'),
                  grades: [gradeWith(id: const GradeId('grade1'))],
                ),
              ],
            ),
          );
          controller = createController(gradeId: const GradeId('grade1'));
          controller.setGradingSystem(GradingSystem.oneToSixWithPlusAndMinus);

          expect(
            controller.view.takeIntoAccountState,
            TakeIntoAccountState.disabledWrongGradingSystem,
          );
        },
      );

      test(
        '$TakeIntoAccountState remains enabled when term and selected grading systems match',
        () {
          gradesTestController.createTerm(
            termWith(gradingSystem: GradingSystem.zeroToFifteenPoints),
          );
          controller = createController();
          controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);

          expect(
            controller.view.takeIntoAccountState,
            TakeIntoAccountState.enabled,
          );
        },
      );
      test(
        '$TakeIntoAccountState remains enabled when term and selected grading systems match (when editing grade)',
        () {
          gradesTestController.createTerm(
            termWith(
              gradingSystem: GradingSystem.zeroToFifteenPoints,
              subjects: [
                subjectWith(
                  id: const SubjectId('maths'),
                  grades: [gradeWith(id: const GradeId('grade1'))],
                ),
              ],
            ),
          );
          controller = createController(gradeId: const GradeId('grade1'));
          controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);

          expect(
            controller.view.takeIntoAccountState,
            TakeIntoAccountState.enabled,
          );
        },
      );
    });

    group('Validation and saving', () {
      test(
        'validate methods set corresponding missing flags to true when invalid',
        () async {
          controller = createController();

          expect(controller.view.isSubjectMissing, isFalse);
          expect(controller.view.isTermMissing, isFalse);
          expect(controller.view.isGradeMissing, isFalse);

          // Try to save without setting required fields
          try {
            await controller.save();
          } catch (_) {}

          expect(controller.view.isSubjectMissing, isTrue);
          expect(controller.view.isTermMissing, isTrue);
          expect(controller.view.isGradeMissing, isTrue);
        },
      );

      test(
        '.save throws correct $InvalidFieldsSaveGradeException when no fields are filled out and save is pressed',
        () async {
          controller.setTitle('');

          expect(
            () async => await controller.save(),
            throwsA(
              InvalidFieldsSaveGradeException(
                ISet({
                  GradingDialogFields.gradeValue,
                  GradingDialogFields.subject,
                  GradingDialogFields.term,
                  GradingDialogFields.title,
                }),
              ),
            ),
          );
        },
      );

      test('analytics is called when grade is saved', () async {
        const termId = TermId('term1');
        const subjectId = SubjectId('subject1');

        gradesTestController.createTerm(
          termWith(
            id: termId,
            subjects: [
              subjectWith(id: subjectId, grades: [gradeWith()]),
            ],
          ),
        );

        controller = createController();
        controller.setGrade('1');
        controller.setTitle('Analytics Test');
        controller.setSubject(subjectId);
        controller.setTerm(termId);

        await controller.save();

        verify(
          analytics.log(NamedAnalyticsEvent(name: 'grade_added')),
        ).called(1);
      });
    });
  });
}
