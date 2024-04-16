// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

void main() {
  group('GradesRepository', () {
    test('serializes expected data map for empty state', () {
      final res = FirestoreGradesStateRepository.toDto((
        customGradeTypes: const IListConst([]),
        subjects: const IListConst([]),
        terms: const IListConst([]),
      ));

      expect(res, {
        'customGradeTypes': {},
        'subjects': {},
        'grades': {},
        'terms': {},
      });
    });
    test('deserializes expected state from data map', () {
      final res = FirestoreGradesStateRepository.fromData({
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
        const GradeType(
          id: GradeTypeId('my-custom-grade-type'),
          displayName: 'My Custom Grade Type',
        ),
      );

      service.addTerm(
        id: const TermId('02-10-term'),
        name: '02/10',
        finalGradeType: GradeType.schoolReportGrade.id,
        gradingSystem: GradingSystem.zeroToFifteenPoints,
        isActiveTerm: true,
      );
      service.addTerm(
        id: const TermId('01-10-term'),
        name: '01/10',
        finalGradeType: const GradeTypeId('my-custom-grade-type'),
        gradingSystem: GradingSystem.oneToSixWithDecimals,
        isActiveTerm: false,
      );

      service.addSubject(Subject(
        id: const SubjectId('mathe'),
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
      ));
      service.addSubject(Subject(
        id: const SubjectId('englisch'),
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
      ));

      service.addGrade(
          subjectId: const SubjectId('mathe'),
          termId: const TermId('02-10-term'),
          value: Grade(
            id: GradeId('grade-1'),
            value: '13',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            type: const GradeTypeId('my-custom-grade-type'),
            date: Date('2024-10-02'),
            takeIntoAccount: true,
            title: 'hallo',
            details: 'hello',
          ));
      service.addGrade(
          subjectId: const SubjectId('mathe'),
          termId: const TermId('02-10-term'),
          value: Grade(
            id: GradeId('grade-2'),
            value: '3',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            type: GradeType.vocabularyTest.id,
            date: Date('2024-10-03'),
            takeIntoAccount: true,
            title: 'abcdef',
            details: 'ghijkl',
          ));

      service.addGrade(
          subjectId: const SubjectId('englisch'),
          termId: const TermId('01-10-term'),
          value: Grade(
            id: GradeId('grade-3'),
            value: 2.25,
            gradingSystem: GradingSystem.oneToSixWithDecimals,
            type: const GradeTypeId('my-custom-grade-type'),
            date: Date('2024-10-16'),
            takeIntoAccount: false,
            title: 'hallo',
            details: 'ollah',
          ));
      service.addGrade(
          subjectId: const SubjectId('englisch'),
          termId: const TermId('01-10-term'),
          value: Grade(
            id: GradeId('grade-4'),
            value: 'Sehr zufriedenstellend',
            gradingSystem: GradingSystem.austrianBehaviouralGrades,
            type: GradeType.oralParticipation.id,
            date: Date('2024-10-18'),
            takeIntoAccount: true,
            title: 'Beep boop',
            details: 'robot noises',
          ));

      service.changeSubjectFinalGradeType(
          id: const SubjectId('englisch'),
          termId: const TermId('01-10-term'),
          gradeType: GradeType.oralParticipation.id);
      service.changeGradeTypeWeightForTerm(
          termId: const TermId('02-10-term'),
          gradeType: GradeType.vocabularyTest.id,
          weight: const Weight.factor(1.5));
      service.changeGradeTypeWeightForSubject(
          id: const SubjectId('mathe'),
          termId: const TermId('02-10-term'),
          gradeType: const GradeTypeId('my-custom-grade-type'),
          weight: const Weight.percent(200));
      service.changeGradeWeight(
          id: GradeId('grade-1'),
          termId: const TermId('02-10-term'),
          weight: const Weight.factor(0.5));
      service.changeSubjectWeightTypeSettings(
          id: const SubjectId('mathe'),
          termId: const TermId('02-10-term'),
          perGradeType: WeightType.perGrade);
      service.changeSubjectWeightForTermGrade(
          id: const SubjectId('mathe'),
          termId: const TermId('02-10-term'),
          weight: const Weight.percent(250));

      final res = repository.data;
      final state = repository.state.value;

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
            'gradingSystem': 'oneToSixWithDecimals',
            'subjectWeights': {
              'englisch': {'value': 1.0, 'type': 'factor'},
            },
            'gradeTypeWeights': {},
            'subjects': {
              'englisch': {
                'id': 'englisch',
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
            'numValue': 13,
            'gradingSystem': 'zeroToFifteenPoints',
            'gradeType': 'my-custom-grade-type',
            'receivedAt': Timestamp.fromMillisecondsSinceEpoch(1727820000000),
            'includeInGrading': true,
            'title': 'hallo',
            'details': 'hello',
            'createdOn': FieldValue.serverTimestamp(),
          },
          'grade-2': {
            'id': 'grade-2',
            'termId': '02-10-term',
            'subjectId': 'mathe',
            'numValue': 3,
            'gradingSystem': 'zeroToFifteenPoints',
            'gradeType': 'vocabulary-test',
            'receivedAt': Timestamp.fromMillisecondsSinceEpoch(1727906400000),
            'includeInGrading': true,
            'title': 'abcdef',
            'details': 'ghijkl',
            'createdOn': FieldValue.serverTimestamp(),
          },
          'grade-3': {
            'id': 'grade-3',
            'termId': '01-10-term',
            'subjectId': 'englisch',
            'numValue': 2.25,
            'gradingSystem': 'oneToSixWithDecimals',
            'gradeType': 'my-custom-grade-type',
            'receivedAt': Timestamp.fromMillisecondsSinceEpoch(1729029600000),
            'includeInGrading': false,
            'title': 'hallo',
            'details': 'ollah',
            'createdOn': FieldValue.serverTimestamp(),
          },
          'grade-4': {
            'id': 'grade-4',
            'termId': '01-10-term',
            'subjectId': 'englisch',
            'numValue': 1,
            'gradingSystem': 'austrianBehaviouralGrades',
            'gradeType': 'oral-participation',
            'receivedAt': Timestamp.fromMillisecondsSinceEpoch(1729202400000),
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
        Term(
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
                    id: GradeId('grade-1'),
                    subjectId: const SubjectId('mathe'),
                    termId: const TermId('02-10-term'),
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
                    id: GradeId('grade-2'),
                    subjectId: const SubjectId('mathe'),
                    termId: const TermId('02-10-term'),
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
                  const GradeTypeId('vocabulary-test'): const Weight.factor(1.5)
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
        Term(
          id: const TermId('01-10-term'),
          subjects: IListConst([
            SubjectModel(
              id: const SubjectId('englisch'),
              name: 'Englisch',
              termId: const TermId('01-10-term'),
              gradingSystem: GradingSystemModel.oneToSixWithDecimals,
              grades: IListConst(
                [
                  GradeModel(
                      id: GradeId('grade-3'),
                      subjectId: const SubjectId('englisch'),
                      termId: const TermId('01-10-term'),
                      value: const GradeValue(
                        asNum: 2.25,
                        gradingSystem: GradingSystem.oneToSixWithDecimals,
                        displayableGrade: null,
                        suffix: null,
                      ),
                      gradingSystem: GradingSystemModel.oneToSixWithDecimals,
                      gradeType: const GradeTypeId('my-custom-grade-type'),
                      takenIntoAccount: false,
                      weight: const Weight.factor(1),
                      date: Date('2024-10-16'),
                      title: 'hallo',
                      details: 'ollah'),
                  GradeModel(
                    id: GradeId('grade-4'),
                    subjectId: const SubjectId('englisch'),
                    termId: const TermId('01-10-term'),
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
          gradingSystem: GradingSystemModel.oneToSixWithDecimals,
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
  });
}

/// We use the Firestore (de-)serialization methods to test the repository.
/// This lets us not depend on Firestore here (and having to mock it).
class TestFirestoreGradesStateRepository extends GradesStateRepository {
  Map<String, Object> data = {};

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
