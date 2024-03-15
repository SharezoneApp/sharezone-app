import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:test_randomness/test_randomness.dart';

import 'grades_2_test.dart';
import 'grades_service.dart';

void main() {
  group('grades', () {
    test(
        'The calculated grade of a subject is the average of the grades by default',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: SubjectId('Mathe'),
            name: 'Mathe',
            grades: [gradeWith(value: 4), gradeWith(value: 1.5)]),
      ]);
      controller.createTerm(term);

      expect(
          controller.term(term.id).subject(SubjectId('Mathe')).calculatedGrade,
          2.75);
    });
    test(
        'The calculated grade of the term is the average of subject grades by default',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: SubjectId('Englisch'),
            name: 'Englisch',
            grades: [gradeWith(value: 2.0), gradeWith(value: 4.0)]),
      ]);
      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade, 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: SubjectId('Englisch'),
            name: 'Englisch',
            weight: const Weight.factor(0.5),
            grades: [gradeWith(value: 3.0)]),
        subjectWith(
            id: SubjectId('Mathe'),
            name: 'Mathe',
            weight: const Weight.factor(1),
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: SubjectId('Informatik'),
            name: 'Informatik',
            // weight: const Weight.factor(2),
            // is the same as:
            weight: const Weight.percent(200),
            grades: [gradeWith(value: 1.0)]),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.5 + 1 + 2;
      const expected = (3 * 0.5 + 2 * 1 + 1 * 2) / sumOfWeights;
      expect(controller.term(term.id).calculatedGrade, expected);
    });
    test(
        'grades that are marked as "Nicht in den Schnitt einbeziehen" should not be included in the calculation of the subject and term grade',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: SubjectId('Sport'),
            name: 'Sport',
            weight: const Weight.factor(0.5),
            grades: [
              gradeWith(value: 3.0, includeInGradeCalculations: false),
              gradeWith(value: 1.5),
            ]),
      ]);
      controller.createTerm(term);

      expect(
          controller.term(term.id).subject(SubjectId('Sport')).calculatedGrade,
          1.5);
      expect(controller.term(term.id).calculatedGrade, 1.5);
    });
    test('subjects can have custom weights per grade type (e.g. presentation)',
        () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
            id: SubjectId('Englisch'),
            name: 'Englisch',
            weightType: WeightType.perGradeType,
            gradeTypeWeights: {
              const GradeType('presentation'): const Weight.factor(0.7),
              const GradeType('vocabulary test'): const Weight.factor(1),
              const GradeType('exam'): const Weight.factor(1.5),
            },
            grades: [
              gradeWith(value: 2.0, type: const GradeType('presentation')),
              gradeWith(value: 1.0, type: const GradeType('exam')),
              gradeWith(value: 1.0, type: const GradeType('vocabulary test')),
            ]),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.7 + 1.5 + 1;
      const expected = (2 * 0.7 + 1 * 1.5 + 1 * 1) / sumOfWeights;
      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Englisch'))
              .calculatedGrade,
          expected);
      expect(controller.term(term.id).calculatedGrade, expected);
    });
    test(
        'subjects can have custom weights per grade type 2 (e.g. presentation)',
        () {
      // Aus Beispiel: https://www.notenapp.com/2023/08/01/notendurchschnitt-berechnen-wie-mache-ich-es-richtig/

      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
          id: SubjectId('Mathe'),
          name: 'Mathe',
          weightType: WeightType.perGradeType,
          gradeTypeWeights: {
            const GradeType('Schulaufgabe'): const Weight.factor(2),
            const GradeType('Abfrage'): const Weight.factor(1),
            const GradeType('Mitarbeitsnote'): const Weight.factor(1),
            const GradeType('Referat'): const Weight.factor(1),
          },
          grades: [
            gradeWith(value: 2.0, type: const GradeType('Schulaufgabe')),
            gradeWith(value: 3.0, type: const GradeType('Schulaufgabe')),
            gradeWith(value: 1.0, type: const GradeType('Abfrage')),
            gradeWith(value: 3.0, type: const GradeType('Abfrage')),
            gradeWith(value: 2.0, type: const GradeType('Mitarbeitsnote')),
            gradeWith(value: 1.0, type: const GradeType('Referat')),
          ],
        ),
      ]);
      controller.createTerm(term);

      expect(
          controller.term(term.id).subject(SubjectId('Mathe')).calculatedGrade,
          2.125);
    });
    test('subjects can have custom weights per grade', () {
      final controller = GradesTestController();

      final term = termWith(subjects: [
        subjectWith(
          id: SubjectId('Mathe'),
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
          controller.term(term.id).subject(SubjectId('Mathe')).calculatedGrade,
          expected);
    });
    test(
        'grades for a subject will be weighted by the settings in term by default',
        () {
      final controller = GradesTestController();

      final term = termWith(
        gradeTypeWeights: {
          const GradeType('presentation'): const Weight.factor(1),
          const GradeType('exam'): const Weight.factor(3),
        },
        subjects: [
          subjectWith(
            id: SubjectId('Deutsch'),
            name: 'Deutsch',
            // This should be the default:
            // weightType: WeightType.inheritFromTerm,
            grades: [
              gradeWith(value: 3.0, type: const GradeType('presentation')),
              gradeWith(value: 1.0, type: const GradeType('exam')),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade, 1.5);
      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Deutsch'))
              .calculatedGrade,
          1.5);
    });
    test('term weights can be overridden by a subject', () {
      final controller = GradesTestController();

      final subjectId = SubjectId('Deutsch');
      final grade1Id = GradeId('grade1');
      final grade2Id = GradeId('grade2');

      final term = termWith(
        gradeTypeWeights: {
          const GradeType('presentation'): const Weight.factor(1),
          const GradeType('exam'): const Weight.factor(3),
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
                type: const GradeType('presentation'),
              ),
              gradeWith(
                id: grade2Id,
                value: 1.0,
                type: const GradeType('exam'),
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);
      final subjectGradeWithInheritedWeights =
          controller.term(term.id).subject(subjectId).calculatedGrade;
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
          const GradeType('presentation'): const Weight.factor(1),
          const GradeType('exam'): const Weight.factor(1),
        },
      );

      final subjectWithOverriddenGradeTypeWeights =
          controller.term(term.id).subject(subjectId).calculatedGrade;
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
          controller.term(term.id).subject(subjectId).calculatedGrade;

      expect(subjectWithOverriddenGradeWeights,
          isNot(subjectWithOverriddenGradeTypeWeights));
      expect(subjectWithOverriddenGradeWeights,
          isNot(subjectGradeWithInheritedWeights));

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: subjectId,
        weightType: WeightType.inheritFromTerm,
      );

      expect(controller.term(term.id).subject(subjectId).calculatedGrade,
          subjectGradeWithInheritedWeights);
    });
    test(
        'a subjects gradeType weights are saved even when they are deactivated',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: SubjectId('Deutsch'),
            name: 'Deutsch',
            weightType: WeightType.perGradeType,
            gradeTypeWeights: {
              const GradeType('presentation'): const Weight.factor(1),
              const GradeType('exam'): const Weight.factor(3),
            },
            grades: [
              gradeWith(
                value: 3.0,
                type: const GradeType('presentation'),
              ),
              gradeWith(
                value: 1.0,
                type: const GradeType('exam'),
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Deutsch'))
              .calculatedGrade,
          1.5);

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: SubjectId('Deutsch'),
        weightType: WeightType.inheritFromTerm,
      );
      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: SubjectId('Deutsch'),
        weightType: WeightType.perGradeType,
      );

      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Deutsch'))
              .calculatedGrade,
          1.5);
    });
    test('a subjects grade weights are saved even when they are deactivated',
        () {
      final controller = GradesTestController();

      final term = termWith(
        subjects: [
          subjectWith(
            id: SubjectId('Deutsch'),
            name: 'Deutsch',
            weightType: WeightType.perGrade,
            grades: [
              gradeWith(
                value: 3.0,
                type: const GradeType('presentation'),
                weight: const Weight.factor(1),
              ),
              gradeWith(
                value: 1.0,
                type: const GradeType('exam'),
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
              .subject(SubjectId('Deutsch'))
              .calculatedGrade,
          1.5);

      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: SubjectId('Deutsch'),
        weightType: WeightType.inheritFromTerm,
      );
      controller.changeWeightTypeForSubject(
        termId: term.id,
        subjectId: SubjectId('Deutsch'),
        weightType: WeightType.perGrade,
      );

      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Deutsch'))
              .calculatedGrade,
          1.5);
    });
    test('The "Endnote" grade type overrides the subject grade', () {
      final controller = GradesTestController();

      final term = termWith(
        finalGradeType: const GradeType('test endnote'),
        subjects: [
          subjectWith(
            id: SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [
              gradeWith(
                value: 3.0,
                type: const GradeType('presentation'),
              ),
              gradeWith(
                value: 1.0,
                type: const GradeType('test endnote'),
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Deutsch'))
              .calculatedGrade,
          1);
    });
    test(
        'A subject can have a custom "Endnote" that overrides the terms "Endnote"',
        () {
      final controller = GradesTestController();

      final term = termWith(
        finalGradeType: const GradeType('term finalGradeType'),
        subjects: [
          subjectWith(
            id: SubjectId('Philosophie'),
            name: 'Philosophie',
            finalGradeType: const GradeType('subject finalGradeType'),
            grades: [
              gradeWith(
                value: 4.0,
                type: const GradeType('term finalGradeType'),
              ),
              gradeWith(
                value: 2.0,
                type: const GradeType('subject finalGradeType'),
              ),
            ],
          ),
        ],
      );
      controller.createTerm(term);

      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Philosophie'))
              .calculatedGrade,
          2.0);

      // Reset the finalGradeType for the subject
      controller.changeFinalGradeTypeForSubject(
        termId: term.id,
        subjectId: SubjectId('Philosophie'),
        gradeType: null,
      );

      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Philosophie'))
              .calculatedGrade,
          4.0);
    });
    test('A user can have several terms', () {
      final controller = GradesTestController();

      final term1 = termWith(
        subjects: [
          subjectWith(
            id: SubjectId('Philosophie'),
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
            id: SubjectId('Sport'),
            name: 'Sport',
            grades: [
              gradeWith(value: 1.0),
            ],
          ),
        ],
      );
      controller.createTerm(term2);

      expect(controller.term(term1.id).calculatedGrade, 4.0);
      expect(controller.term(term2.id).calculatedGrade, 1.0);
    });
  });
}

class GradesTestController {
  final service = GradesService();

  void createTerm(TestTerm testTerm) {
    final termId = testTerm.id;
    service.createTerm(id: termId, finalGradeType: testTerm.finalGradeType);

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
          value: Grade(id: grade.id, value: grade.value, type: grade.type),
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
      required Map<GradeType, Weight> gradeTypeWeights}) {
    for (var e in gradeTypeWeights.entries) {
      service.changeGradeTypeWeightForSubject(
          id: subjectId, termId: termId, gradeType: e.key, weight: e.value);
    }
  }

  void changeFinalGradeTypeForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required GradeType? gradeType}) {
    service.changeSubjectFinalGradeType(
        id: subjectId, termId: termId, gradeType: gradeType);
  }
}

class Weight extends Equatable {
  final num asFactor;
  num get asPercentage => asFactor * 100;
  @override
  List<Object?> get props => [asFactor];

  const Weight.percent(num percent) : asFactor = percent / 100;
  const Weight.factor(this.asFactor);

  @override
  String toString() {
    return 'Weight($asFactor / $asPercentage%)';
  }
}

class TermResult {
  final TermId id;
  final num? calculatedGrade;
  IMap<SubjectId, SubjectRes> subjects;

  SubjectRes subject(SubjectId id) {
    final subject = subjects.get(id)!;
    return SubjectRes(
      calculatedGrade: subject.calculatedGrade,
      weightType: subject.weightType,
      gradeTypeWeights: subject.gradeTypeWeights,
    );
  }

  TermResult({
    required this.id,
    required this.calculatedGrade,
    required this.subjects,
  });
}

class SubjectRes {
  final num? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeType, Weight> gradeTypeWeights;

  SubjectRes({
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
  });
}

TestTerm termWith({
  String? name,
  List<TestSubject> subjects = const [],
  Map<GradeType, Weight>? gradeTypeWeights,
  GradeType finalGradeType = const GradeType('Endnote'),
}) {
  final rdm = randomAlpha(5);
  return TestTerm(
    id: TermId(rdm),
    name: name ?? 'Test term $rdm',
    subjects: IMap.fromEntries(subjects.map((s) => MapEntry(s.id, s))),
    gradeTypeWeights: gradeTypeWeights,
    finalGradeType: finalGradeType,
  );
}

class TestTerm {
  final TermId id;
  final String name;
  final IMap<SubjectId, TestSubject> subjects;
  final Map<GradeType, Weight>? gradeTypeWeights;
  final GradeType finalGradeType;

  TestTerm({
    required this.id,
    required this.name,
    required this.subjects,
    required this.finalGradeType,
    this.gradeTypeWeights,
  });
}

TestSubject subjectWith({
  required SubjectId id,
  required String name,
  required List<TestGrade> grades,
  Weight? weight,
  WeightType? weightType,
  Map<GradeType, Weight> gradeTypeWeights = const {},
  GradeType? finalGradeType,
}) {
  return TestSubject(
    id: id,
    name: name,
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
  final Map<GradeType, Weight> gradeTypeWeights;
  final Weight? weight;
  final GradeType? finalGradeType;

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
  required double value,
  bool includeInGradeCalculations = true,
  GradeType type = const GradeType('some test type'),
  Weight? weight,
  GradeId? id,
}) {
  return TestGrade(
    id: id ?? GradeId(randomAlpha(5)),
    value: value,
    includeInGradeCalculations: includeInGradeCalculations,
    type: type,
    weight: weight,
  );
}

class TestGrade {
  final GradeId id;
  final double value;
  final bool includeInGradeCalculations;
  final GradeType type;
  final Weight? weight;

  TestGrade({
    required this.id,
    required this.value,
    required this.includeInGradeCalculations,
    required this.type,
    this.weight,
  });
}
