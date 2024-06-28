// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

import 'grades_test_common.dart';

void main() {
  group('GradesRepository', () {
    group('basic repository tests', () {
      late GradesStateRepository repository;
      late GradesService service;
      late GradesTestController controller;

      setUp(() {
        repository = InMemoryGradesStateRepository();
        service = GradesService(repository: repository);
        controller = GradesTestController(gradesService: service);
      });

      void replaceGradesServiceWithSameRepository() {
        controller.service = GradesService(repository: repository);
      }

      test(
          'A term is still saved when deleting the Grade service as long as the repository is the same',
          () {
        var term = termWith(name: 'term1');
        controller.createTerm(term);

        replaceGradesServiceWithSameRepository();

        expect(controller.terms, hasLength(1));
      });
      test(
          'A gradeType is still saved when deleting the Grade service as long as the repository is the same',
          () {
        const gradeType = GradeType(id: GradeTypeId('foo'), displayName: 'Foo');
        controller.createCustomGradeType(gradeType);

        replaceGradesServiceWithSameRepository();

        expect(controller.getPossibleGradeTypes(), contains(gradeType));
      });
      test(
          'A subject is still saved when deleting the Grade service as long as the repository is the same',
          () {
        var subject =
            subjectWith(id: const SubjectId('foo'), name: 'Foo Subject');
        controller.addSubject(subject);

        replaceGradesServiceWithSameRepository();

        expect(
          controller.getSubjects(),
          contains(
            predicate<TestSubject>(
              (sub) => sub.id == subject.id && sub.name == subject.name,
            ),
          ),
        );
      });
      test(
          'If the $GradesService is replaced without the same $GradesStateRepository then old values wont be there anymore',
          () {
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

        // We don't reuse the repository here, so the data will be lost
        controller.service =
            GradesService(repository: InMemoryGradesStateRepository());

        expect(controller.terms, isEmpty);
      });
    });
    test('when deleting a term the currentTerm is set to null', () {
      final repository = TestFirestoreGradesStateRepository();
      final controller = GradesTestController(
          gradesService: GradesService(repository: repository));

      final term = termWith(name: 'term1');
      controller.createTerm(term);
      controller.deleteTerm(term.id);

      // containsKey should be true as otherwise Firestore won't change the
      // currentTerm to null
      expect(repository.data.containsKey('currentTerm'), isTrue);
      expect(repository.data['currentTerm'], isNull);
    });
    test('serializes expected data map for empty state', () {
      final res = FirestoreGradesStateRepository.toDto((
        customGradeTypes: const IListConst([]),
        subjects: const IListConst([]),
        terms: const IListConst([]),
      ));

      expect(res, {
        'currentTerm': null,
        'customGradeTypes': {},
        'subjects': {},
        'grades': {},
        'terms': {},
      });
    });
    test('deserializes expected state from data map', () {
      final res = FirestoreGradesStateRepository.fromData({
        'currentTerm': null,
        'customGradeTypes': {},
        'subjects': {},
        'grades': {},
        'terms': {},
      });

      expect(res, (
        customGradeTypes: const IListConst([]),
        subjects: const IListConst([]),
        terms: const IListConst([]),
      ));
    });
    test('serializes expected data map for service usage', () {
      final repository = TestFirestoreGradesStateRepository();
      final service = GradesService(repository: repository);
      final random = Random(42);

      service.addCustomGradeType(
        id: const GradeTypeId('my-custom-grade-type'),
        displayName: 'My Custom Grade Type',
      );

      final term0210 = service.addTerm(
        id: const TermId('02-10-term'),
        name: '02/10',
        finalGradeType: GradeType.schoolReportGrade.id,
        gradingSystem: GradingSystem.zeroToFifteenPoints,
        isActiveTerm: true,
      );
      final term0110 = service.addTerm(
        id: const TermId('01-10-term'),
        name: '01/10',
        finalGradeType: const GradeTypeId('my-custom-grade-type'),
        gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
        isActiveTerm: false,
      );

      service.addSubject(
        id: const SubjectId('mathe'),
        SubjectInput(
          design: Design.random(random),
          name: 'Mathe',
          abbreviation: 'M',
          connectedCourses: const IListConst([
            ConnectedCourse(
              id: CourseId('connected-mathe-course'),
              name: 'Mathe 8a',
              abbreviation: 'M',
              subjectName: 'Mathe',
            )
          ]),
        ),
      );
      service.addSubject(
        id: const SubjectId('englisch'),
        SubjectInput(
          design: Design.random(random),
          name: 'Englisch',
          abbreviation: 'E',
          connectedCourses: const IListConst([
            ConnectedCourse(
              id: CourseId('connected-englisch-course'),
              name: 'Englisch 8a',
              abbreviation: 'E',
              subjectName: 'Englisch',
            )
          ]),
        ),
      );

      final mathGrade1 = term0210
          .subject(const SubjectId('mathe'))
          .grade(const GradeId('grade-1'))
          .create(GradeInput(
            value: '13',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            type: const GradeTypeId('my-custom-grade-type'),
            date: Date('2024-10-02'),
            takeIntoAccount: true,
            title: 'hallo',
            details: 'hello',
          ));
      final mathGrade2 = term0210
          .subject(const SubjectId('mathe'))
          .grade(const GradeId('grade-2'))
          .create(GradeInput(
            value: '3',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            type: GradeType.vocabularyTest.id,
            date: Date('2024-10-03'),
            takeIntoAccount: true,
            title: 'abcdef',
            details: 'ghijkl',
          ));
      final englishGrade1 = term0110
          .subject(const SubjectId('englisch'))
          .grade(const GradeId('grade-3'))
          .create(GradeInput(
            value: '2-',
            gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
            type: const GradeTypeId('my-custom-grade-type'),
            date: Date('2024-10-16'),
            takeIntoAccount: false,
            title: 'hallo',
            details: 'ollah',
          ));
      final englishGrade2 = term0110
          .subject(const SubjectId('englisch'))
          .grade(const GradeId('grade-4'))
          .create(GradeInput(
            value: 'Sehr zufriedenstellend',
            gradingSystem: GradingSystem.austrianBehaviouralGrades,
            type: GradeType.oralParticipation.id,
            date: Date('2024-10-18'),
            takeIntoAccount: true,
            title: 'Beep boop',
            details: 'robot noises',
          ));

      term0110
          .subject(const SubjectId('englisch'))
          .changeFinalGradeType(GradeType.oralParticipation.id);

      term0210.changeGradeTypeWeight(
          GradeType.vocabularyTest.id, const Weight.factor(1.5));

      term0210.subject(const SubjectId('mathe'))
        ..changeGradeTypeWeight(const GradeTypeId('my-custom-grade-type'),
            const Weight.percent(200))
        ..grade(GradeId('grade-1')).changeWeight(const Weight.factor(0.5))
        ..changeWeightType(WeightType.perGrade)
        ..changeWeightForTermGrade(const Weight.percent(250));

      final res = repository.data;

      expect(res, {
        'currentTerm': '02-10-term',
        'terms': {
          '02-10-term': {
            'id': '02-10-term',
            'displayName': '02/10',
            'createdOn': FieldValue.serverTimestamp(),
            'gradingSystem': 'zeroToFifteenPoints',
            'subjectWeights': {
              'mathe': {
                'value': 2.5,
                'type': 'factor',
              }
            },
            'gradeTypeWeights': {
              'vocabulary-test': {'value': 1.5, 'type': 'factor'}
            },
            'subjects': {
              'mathe': {
                'id': 'mathe',
                'createdOn': FieldValue.serverTimestamp(),
                'grades': ['grade-1', 'grade-2'],
                'gradeComposition': {
                  'weightType': 'perGrade',
                  'gradeTypeWeights': {
                    'my-custom-grade-type': {'value': 2.0, 'type': 'factor'}
                  },
                  'gradeWeights': {
                    'grade-1': {
                      'value': 0.5,
                      'type': 'factor',
                    },
                    'grade-2': {
                      'value': 1.0,
                      'type': 'factor',
                    },
                  }
                },
                'finalGradeType': 'school-report-grade'
              }
            },
            'finalGradeType': 'school-report-grade'
          },
          '01-10-term': {
            'id': '01-10-term',
            'displayName': '01/10',
            'createdOn': FieldValue.serverTimestamp(),
            'gradingSystem': 'oneToSixWithPlusAndMinus',
            'subjectWeights': {
              'englisch': {'value': 1.0, 'type': 'factor'},
            },
            'gradeTypeWeights': {},
            'subjects': {
              'englisch': {
                'id': 'englisch',
                'createdOn': FieldValue.serverTimestamp(),
                'grades': ['grade-3', 'grade-4'],
                'gradeComposition': {
                  'weightType': 'inheritFromTerm',
                  'gradeTypeWeights': {},
                  'gradeWeights': {
                    'grade-3': {
                      'value': 1.0,
                      'type': 'factor',
                    },
                    'grade-4': {
                      'value': 1.0,
                      'type': 'factor',
                    },
                  }
                },
                'finalGradeType': 'oral-participation'
              },
            },
            'finalGradeType': 'my-custom-grade-type'
          }
        },
        'grades': {
          'grade-1': {
            'id': 'grade-1',
            'termId': '02-10-term',
            'subjectId': 'mathe',
            'originalInput': '13',
            'numValue': 13,
            'gradingSystem': 'zeroToFifteenPoints',
            'gradeType': 'my-custom-grade-type',
            'receivedAt': '2024-10-02',
            'includeInGrading': true,
            'title': 'hallo',
            'details': 'hello',
            'createdOn': FieldValue.serverTimestamp(),
          },
          'grade-2': {
            'id': 'grade-2',
            'termId': '02-10-term',
            'subjectId': 'mathe',
            'originalInput': '3',
            'numValue': 3,
            'gradingSystem': 'zeroToFifteenPoints',
            'gradeType': 'vocabulary-test',
            'receivedAt': '2024-10-03',
            'includeInGrading': true,
            'title': 'abcdef',
            'details': 'ghijkl',
            'createdOn': FieldValue.serverTimestamp(),
          },
          'grade-3': {
            'id': 'grade-3',
            'termId': '01-10-term',
            'subjectId': 'englisch',
            'originalInput': '2-',
            'numValue': 2.25,
            'gradingSystem': 'oneToSixWithPlusAndMinus',
            'gradeType': 'my-custom-grade-type',
            'receivedAt': '2024-10-16',
            'includeInGrading': false,
            'title': 'hallo',
            'details': 'ollah',
            'createdOn': FieldValue.serverTimestamp(),
          },
          'grade-4': {
            'id': 'grade-4',
            'termId': '01-10-term',
            'subjectId': 'englisch',
            'originalInput': 'verySatisfactory',
            'numValue': 1,
            'gradingSystem': 'austrianBehaviouralGrades',
            'gradeType': 'oral-participation',
            'receivedAt': '2024-10-18',
            'includeInGrading': true,
            'title': 'Beep boop',
            'details': 'robot noises',
            'createdOn': FieldValue.serverTimestamp(),
          },
        },
        'customGradeTypes': {
          'my-custom-grade-type': {
            'id': 'my-custom-grade-type',
            'displayName': 'My Custom Grade Type',
          }
        },
        'subjects': {
          'mathe': {
            'id': 'mathe',
            'name': 'Mathe',
            'abbreviation': 'M',
            'createdOn': FieldValue.serverTimestamp(),
            'design': {'color': '795548', 'type': 'color'},
            'connectedCourses': {
              'connected-mathe-course': {
                'id': 'connected-mathe-course',
                'name': 'Mathe 8a',
                'abbreviation': 'M',
                'subjectName': 'Mathe'
              }
            }
          },
          'englisch': {
            'id': 'englisch',
            'name': 'Englisch',
            'abbreviation': 'E',
            'createdOn': FieldValue.serverTimestamp(),
            'design': {'color': '000000', 'type': 'color'},
            'connectedCourses': {
              'connected-englisch-course': {
                'id': 'connected-englisch-course',
                'name': 'Englisch 8a',
                'abbreviation': 'E',
                'subjectName': 'Englisch'
              }
            }
          }
        }
      });

      final state = repository.state.value;

      expect(
          state.customGradeTypes,
          const IListConst([
            GradeType(
              id: GradeTypeId('my-custom-grade-type'),
              displayName: 'My Custom Grade Type',
            ),
          ]));

      expect(
          state.subjects,
          IListConst([
            Subject(
              id: const SubjectId('mathe'),
              design: Design.fromData('795548'),
              name: 'Mathe',
              abbreviation: 'M',
              connectedCourses: const IListConst(
                [
                  ConnectedCourse(
                      id: CourseId('connected-mathe-course'),
                      name: 'Mathe 8a',
                      abbreviation: 'M',
                      subjectName: 'Mathe')
                ],
              ),
            ),
            Subject(
              id: const SubjectId('englisch'),
              design: Design.fromData('000000'),
              name: 'Englisch',
              abbreviation: 'E',
              connectedCourses: const IListConst(
                [
                  ConnectedCourse(
                    id: CourseId('connected-englisch-course'),
                    name: 'Englisch 8a',
                    abbreviation: 'E',
                    subjectName: 'Englisch',
                  )
                ],
              ),
            ),
          ]));

      final expectedTerms = [
        TermModel(
          id: const TermId('02-10-term'),
          subjects: IListConst(
            [
              SubjectModel(
                id: const SubjectId('mathe'),
                name: 'Mathe',
                termId: const TermId('02-10-term'),
                gradingSystem: GradingSystemModel.zeroToFifteenPoints,
                grades: IListConst([
                  GradeModel(
                    id: const GradeId('grade-1'),
                    subjectId: const SubjectId('mathe'),
                    termId: const TermId('02-10-term'),
                    originalInput: '13',
                    value: const GradeValue(
                        asNum: 13,
                        gradingSystem: GradingSystem.zeroToFifteenPoints,
                        displayableGrade: null,
                        suffix: null),
                    gradingSystem: GradingSystemModel.zeroToFifteenPoints,
                    gradeType: const GradeTypeId('my-custom-grade-type'),
                    takenIntoAccount: true,
                    weight: const Weight.factor(0.5),
                    date: Date('2024-10-02'),
                    title: 'hallo',
                    details: 'hello',
                  ),
                  GradeModel(
                    id: const GradeId('grade-2'),
                    subjectId: const SubjectId('mathe'),
                    termId: const TermId('02-10-term'),
                    originalInput: 3,
                    value: const GradeValue(
                      asNum: 3,
                      gradingSystem: GradingSystem.zeroToFifteenPoints,
                      displayableGrade: null,
                      suffix: null,
                    ),
                    gradingSystem: GradingSystemModel.zeroToFifteenPoints,
                    gradeType: const GradeTypeId('vocabulary-test'),
                    takenIntoAccount: true,
                    weight: const Weight.factor(1),
                    // weight: const Weight.factor(0.5),
                    // date: Date('2024-10-02'),
                    date: Date('2024-10-03'),
                    title: 'abcdef',
                    details: 'ghijkl',
                  ),
                ]),
                finalGradeType: const GradeTypeId('school-report-grade'),
                isFinalGradeTypeOverridden: false,
                weightingForTermGrade: const Weight.factor(2.5),
                gradeTypeWeightings: IMapConst({
                  const GradeTypeId('my-custom-grade-type'):
                      const Weight.factor(2.0)
                }),
                gradeTypeWeightingsFromTerm: IMapConst({
                  const GradeTypeId('vocabulary-test'): const Weight.factor(1.5)
                }),
                weightType: WeightType.perGrade,
                abbreviation: 'M',
                design: Design.fromData('795548'),
                connectedCourses: const IListConst(
                  [
                    ConnectedCourse(
                      id: CourseId('connected-mathe-course'),
                      name: 'Mathe 8a',
                      abbreviation: 'M',
                      subjectName: 'Mathe',
                    )
                  ],
                ),
              )
            ],
          ),
          gradeTypeWeightings: IMapConst(
              {const GradeTypeId('vocabulary-test'): const Weight.factor(1.5)}),
          gradingSystem: GradingSystemModel.zeroToFifteenPoints,
          finalGradeType: const GradeTypeId('school-report-grade'),
          isActiveTerm: true,
          name: '02/10',
        ),
        TermModel(
          id: const TermId('01-10-term'),
          subjects: IListConst([
            SubjectModel(
              id: const SubjectId('englisch'),
              name: 'Englisch',
              termId: const TermId('01-10-term'),
              gradingSystem: GradingSystemModel.oneToSixWithPlusAndMinus,
              grades: IListConst(
                [
                  GradeModel(
                    id: const GradeId('grade-3'),
                    subjectId: const SubjectId('englisch'),
                    termId: const TermId('01-10-term'),
                    originalInput: '2-',
                    value: const GradeValue(
                      asNum: 2.25,
                      gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
                      displayableGrade: '2-',
                      suffix: null,
                    ),
                    gradingSystem: GradingSystemModel.oneToSixWithPlusAndMinus,
                    gradeType: const GradeTypeId('my-custom-grade-type'),
                    takenIntoAccount: false,
                    weight: const Weight.factor(1),
                    date: Date('2024-10-16'),
                    title: 'hallo',
                    details: 'ollah',
                  ),
                  GradeModel(
                    id: const GradeId('grade-4'),
                    subjectId: const SubjectId('englisch'),
                    termId: const TermId('01-10-term'),
                    originalInput: 'Sehr zufriedenstellend',
                    value: const GradeValue(
                        asNum: 1,
                        gradingSystem: GradingSystem.austrianBehaviouralGrades,
                        displayableGrade: 'Sehr zufriedenstellend',
                        suffix: null),
                    gradingSystem: GradingSystemModel.austrianBehaviouralGrades,
                    gradeType: const GradeTypeId('oral-participation'),
                    takenIntoAccount: true,
                    weight: const Weight.factor(1),
                    date: Date('2024-10-18'),
                    title: 'Beep boop',
                    details: 'robot noises',
                  ),
                ],
              ),
              finalGradeType: const GradeTypeId('oral-participation'),
              isFinalGradeTypeOverridden: true,
              weightingForTermGrade: const Weight.factor(1),
              gradeTypeWeightings: const IMapConst({}),
              gradeTypeWeightingsFromTerm: const IMapConst({}),
              weightType: WeightType.inheritFromTerm,
              abbreviation: 'E',
              design: Design.fromData('000000'),
              connectedCourses: const IListConst(
                [
                  ConnectedCourse(
                    id: CourseId('connected-englisch-course'),
                    name: 'Englisch 8a',
                    abbreviation: 'E',
                    subjectName: 'Englisch',
                  )
                ],
              ),
            )
          ]),
          gradeTypeWeightings: const IMapConst({}),
          gradingSystem: GradingSystemModel.oneToSixWithPlusAndMinus,
          finalGradeType: const GradeTypeId('my-custom-grade-type'),
          isActiveTerm: false,
          name: '01/10',
        )
      ];

      expect(state.terms.length, expectedTerms.length);

      // This does not work and I couldn't figure out why
      // So we have to do it manually
      // expect(state.terms, expectedTerms);

      for (var actual in state.terms) {
        final expected = expectedTerms.firstWhere(
          (element) => element.id == actual.id,
        );

        expect(actual.id, expected.id);
        expect(actual.gradeTypeWeightings, expected.gradeTypeWeightings);
        expect(actual.gradingSystem, expected.gradingSystem);
        expect(actual.finalGradeType, expected.finalGradeType);
        expect(actual.isActiveTerm, expected.isActiveTerm);
        expect(actual.name, expected.name);

        // This does not work and I couldn't figure out why
        // So we have to do it manually
        // expect(actual.subjects, expected.subjects);
        for (var actualSub in actual.subjects) {
          final expectedSub = expected.subjects.firstWhere(
            (element) => element.id == actualSub.id,
          );
          expect(actualSub.id, expectedSub.id);

          expect(actualSub.id, expectedSub.id);
          expect(actualSub.name, expectedSub.name);
          expect(actualSub.termId, expectedSub.termId);
          expect(actualSub.gradingSystem, expectedSub.gradingSystem);
          expect(actualSub.grades, expectedSub.grades);
          expect(actualSub.finalGradeType, expectedSub.finalGradeType);
          expect(actualSub.isFinalGradeTypeOverridden,
              expectedSub.isFinalGradeTypeOverridden);
          expect(actualSub.weightingForTermGrade,
              expectedSub.weightingForTermGrade);
          expect(
              actualSub.gradeTypeWeightings, expectedSub.gradeTypeWeightings);
          expect(actualSub.gradeTypeWeightingsFromTerm,
              expectedSub.gradeTypeWeightingsFromTerm);
          expect(actualSub.weightType, expectedSub.weightType);
          expect(actualSub.abbreviation, expectedSub.abbreviation);
          expect(actualSub.design, expectedSub.design);
          expect(actualSub.connectedCourses, expectedSub.connectedCourses);
        }
      }
    });
    test('Regression test: Assigning subject to wrong term', () async {
      final serialized = {
        "customGradeTypes": {},
        "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713619198113),
        "currentTerm": "dZDMkmAlQcO4dHNGECUv",
        "grades": {
          "zodKhqqPXqlJymvAVFgB": {
            "termId": "dZDMkmAlQcO4dHNGECUv",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "id": "zodKhqqPXqlJymvAVFgB",
            "includeInGrading": true,
            "title": "Schriftliche Prüfung",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713630048656),
            "receivedAt": "2024-04-20",
            "subjectId": "JTtl5QaZi0gQJXdNLhAA",
            "gradeType": "written-exam",
            "numValue": 0.75,
            "originalInput": "1+"
          },
          "ireW8wfUQ5zjTWoD5ZVv": {
            "termId": "dZDMkmAlQcO4dHNGECUv",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "id": "ireW8wfUQ5zjTWoD5ZVv",
            "includeInGrading": true,
            "title": "Schriftliche Prüfung",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713630128192),
            "receivedAt": "2024-04-20",
            "subjectId": "JTtl5QaZi0gQJXdNLhAA",
            "gradeType": "written-exam",
            "numValue": 0.75,
            "originalInput": "1+"
          },
          "r68OpeJ32Cb8jDtsBEq4": {
            "termId": "dZDMkmAlQcO4dHNGECUv",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "id": "r68OpeJ32Cb8jDtsBEq4",
            "includeInGrading": true,
            "title": "Schriftliche Prüfung",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713630098113),
            "receivedAt": "2024-04-20",
            "subjectId": "JTtl5QaZi0gQJXdNLhAA",
            "gradeType": "written-exam",
            "numValue": 0.75,
            "originalInput": "1+"
          },
          "DI9t96aoHreq08OnsoEH": {
            "termId": "t3hTR0qWMm9MhpU1CwUR",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "id": "DI9t96aoHreq08OnsoEH",
            "includeInGrading": true,
            "title": "Schriftliche Prüfung",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713619204303),
            "receivedAt": "2024-04-20",
            "subjectId": "JTtl5QaZi0gQJXdNLhAA",
            "gradeType": "written-exam",
            "numValue": 0.75,
            "originalInput": "1+"
          },
          "6Mb4O6Mgo5h5dlgxTJ3I": {
            "termId": "t3hTR0qWMm9MhpU1CwUR",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "id": "6Mb4O6Mgo5h5dlgxTJ3I",
            "includeInGrading": true,
            "title": "Schriftliche Prüfung",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713620527574),
            "receivedAt": "2024-04-20",
            "subjectId": "iJfPlj4i6UJFePj2lKWC",
            "gradeType": "written-exam",
            "numValue": 0.75,
            "originalInput": "1+"
          }
        },
        "terms": {
          "t3hTR0qWMm9MhpU1CwUR": {
            "displayName": "test",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "subjects": {
              "JTtl5QaZi0gQJXdNLhAA": {
                "gradeComposition": {
                  "weightType": "inheritFromTerm",
                  "gradeTypeWeights": {},
                  "gradeWeights": {
                    "zodKhqqPXqlJymvAVFgB": {"type": "factor", "value": 1},
                    "DI9t96aoHreq08OnsoEH": {"type": "factor", "value": 1},
                    "r68OpeJ32Cb8jDtsBEq4": {"type": "factor", "value": 1}
                  }
                },
                "createdOn":
                    Timestamp.fromMillisecondsSinceEpoch(1713630098113),
                "id": "JTtl5QaZi0gQJXdNLhAA",
                "finalGradeType": "school-report-grade",
                "grades": ["zodKhqqPXqlJymvAVFgB", "r68OpeJ32Cb8jDtsBEq4"]
              },
              "iJfPlj4i6UJFePj2lKWC": {
                "gradeComposition": {
                  "weightType": "inheritFromTerm",
                  "gradeTypeWeights": {},
                  "gradeWeights": {
                    "6Mb4O6Mgo5h5dlgxTJ3I": {"type": "factor", "value": 1}
                  }
                },
                "createdOn":
                    Timestamp.fromMillisecondsSinceEpoch(1713620527574),
                "id": "iJfPlj4i6UJFePj2lKWC",
                "finalGradeType": "school-report-grade",
                "grades": ["6Mb4O6Mgo5h5dlgxTJ3I"]
              }
            },
            "id": "t3hTR0qWMm9MhpU1CwUR",
            "finalGradeType": "school-report-grade",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713619198068),
            "subjectWeights": {
              "JTtl5QaZi0gQJXdNLhAA": {"type": "factor", "value": 1},
              "iJfPlj4i6UJFePj2lKWC": {"type": "factor", "value": 1}
            },
            "gradeTypeWeights": {}
          },
          "dZDMkmAlQcO4dHNGECUv": {
            "displayName": "123",
            "gradingSystem": "oneToSixWithPlusAndMinus",
            "subjects": {
              "JTtl5QaZi0gQJXdNLhAA": {
                "gradeComposition": {
                  "weightType": "inheritFromTerm",
                  "gradeTypeWeights": {},
                  "gradeWeights": {
                    "ireW8wfUQ5zjTWoD5ZVv": {"type": "factor", "value": 1},
                    "zodKhqqPXqlJymvAVFgB": {"type": "factor", "value": 1},
                    "r68OpeJ32Cb8jDtsBEq4": {"type": "factor", "value": 1}
                  }
                },
                "createdOn":
                    Timestamp.fromMillisecondsSinceEpoch(1713630128192),
                "id": "JTtl5QaZi0gQJXdNLhAA",
                "finalGradeType": "school-report-grade",
                "grades": ["ireW8wfUQ5zjTWoD5ZVv"]
              }
            },
            "id": "dZDMkmAlQcO4dHNGECUv",
            "finalGradeType": "school-report-grade",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713629975858),
            "subjectWeights": {
              "JTtl5QaZi0gQJXdNLhAA": {"type": "factor", "value": 1}
            },
            "gradeTypeWeights": {
              "oral-participation": {"type": "factor", "value": 0.5},
              "written-exam": {"type": "factor", "value": 0.5}
            }
          }
        },
        "subjects": {
          "JTtl5QaZi0gQJXdNLhAA": {
            "abbreviation": "D",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713619203273),
            "id": "JTtl5QaZi0gQJXdNLhAA",
            "design": {"color": "03a9f4", "type": "color"},
            "name": "Deutsch",
            "connectedCourses": {
              "35aDFQgopZZOdhTZjxQy": {
                "abbreviation": "D",
                "id": "35aDFQgopZZOdhTZjxQy",
                "name": "Deutsch",
                "subjectName": "Deutsch"
              }
            }
          },
          "iJfPlj4i6UJFePj2lKWC": {
            "abbreviation": "F",
            "createdOn": Timestamp.fromMillisecondsSinceEpoch(1713620526549),
            "id": "iJfPlj4i6UJFePj2lKWC",
            "design": {"color": "ffab40", "type": "color"},
            "name": "Französisch",
            "connectedCourses": {
              "TRqJgCBJs4BEACRvv8cj": {
                "abbreviation": "F",
                "id": "TRqJgCBJs4BEACRvv8cj",
                "name": "Französisch",
                "subjectName": "Französisch"
              }
            }
          }
        }
      };

      final repo = InMemoryGradesStateRepository();
      final controller = GradesTestController(
        gradesService: GradesService(repository: repo),
      );

      repo.state.add(FirestoreGradesStateRepository.fromData(serialized));
      // Because the stream is async we need to await here so the views are
      // updated
      await Future.delayed(Duration.zero);

      expect(controller.terms, hasLength(2));
      expect(
          controller
              .term(const TermId('t3hTR0qWMm9MhpU1CwUR'))
              .subjects
              .map((s) => s.id)
              .toList(),
          const [
            SubjectId('JTtl5QaZi0gQJXdNLhAA'),
            SubjectId('iJfPlj4i6UJFePj2lKWC')
          ]);
      expect(
          controller
              .term(const TermId('dZDMkmAlQcO4dHNGECUv'))
              .subjects
              .map((s) => s.id)
              .toList(),
          [const SubjectId('JTtl5QaZi0gQJXdNLhAA')]);
    });
  });
}

/// We use the Firestore (de-)serialization methods to test the repository.
/// This lets us not depend on Firestore here (and having to mock it).
class TestFirestoreGradesStateRepository extends GradesStateRepository {
  Map<String, Object?> data = {};

  @override
  BehaviorSubject<GradesState> state = BehaviorSubject<GradesState>.seeded(
    (
      terms: const IListConst([]),
      customGradeTypes: const IListConst([]),
      subjects: const IListConst([]),
    ),
  );

  @override
  void updateState(GradesState state) {
    data = FirestoreGradesStateRepository.toDto(state);
    final newState = FirestoreGradesStateRepository.fromData(data);
    this.state.add(newState);
  }
}
